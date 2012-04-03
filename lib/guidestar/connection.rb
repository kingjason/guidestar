module Guidestar

  class Connection

    attr_reader :username, :password

    def initialize(username, password, proxy=nil)
      @username = username
      @password = password
      @proxy = proxy
    end

    def post(data)
      request :post, data
    end

  private

    def request(method, data)
      response = send_request(method, construct_document(data))

      deconstruct_document response
    end

    def send_request(method, data)
      RestClient.proxy = @proxy unless @proxy.nil?

      begin
        response = RestClient.post(ENDPOINT, :xmlInput => data, :multipart => false)
      rescue => e
        raise_errors(e.response)
      end

      response
    end

    def construct_document(data)
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.query {
          xml.version data[:version]
          xml.login @username
          xml.password @password
          xml.pageSize data[:pageSize]
          xml.offset data[:offset]
          xml.orgName data[:orgName]    if data[:orgName]
          xml.ein data[:ein]            if data[:ein]
          xml.city data[:city]          if data[:city]
          xml.state data[:state]        if data[:state]
          xml.zip data[:zip]            if data[:zip]
          xml.nteeCode data[:nteeCode]  if data[:nteeCode]
          if data[:categories] && data[:categories].is_a?(Array)
            data[:categories].each {|category| xml.category category }
          end

          if data[:sub_categories] && data[:sub_categories].is_a?(Array)
            data[:sub_categories].each {|sub_category| xml.subCategory sub_category }
          end
        }
      end

      builder.to_xml
    end

    def deconstruct_document(response)
      organizations = []
      raise(Timeout, "The Guidestar server could not be reached") if response.nil?

      begin
        doc = Nokogiri::XML.parse(CGI.unescapeHTML(response.body))
        doc.remove_namespaces!
        doc.xpath('//organizations/organization').each do |org|
          organization = {}
          org.xpath('.//generalInformation').each do |info|
            organization[:name] = info.at('orgName').text.strip
            organization[:ein] = info.at('ein').text.gsub('-', '')
            organization[:website] = info.at('url').text
            organization[:ruling_date] = info.at('rulingYear').text
            organization[:asset_amount] = info.at('assets').text ? info.at('assets').text.to_i : nil
            organization[:annual_revenue] = info.at('income').text ? info.at('income').text.to_i : nil
            organization[:alternate_name] = info.at('aka').text

            info.xpath('.//address').each do |address|
              organization[:address] = address.at('addressLine1').text
              organization[:address2] = address.at('addressLine2').text
              organization[:city] = address.at('city').text
              organization[:state] = address.at('state').text
              organization[:zip] = address.at('zip').text
            end

            info.xpath('.//contact').each do |contact|
              organization[:contact_name] = [contact.at('firstName').text, contact.at('lastName').text].join(' ')
              organization[:email] = contact.at('email').text
              organization[:phone] = contact.at('phone').text
              organization[:fax] = contact.at('fax').text
            end

            organization[:non_profit] = true

            organization[:ntees] = []
            info.xpath('.//ntees/ntee').each do |ntee|
              next if ntee.at('code').text == ""
              organization[:ntees] << { :code => ntee.at('code').text, :description => ntee.at('description').text }
            end

          end

          organizations << tidy_org(organization)
        end
      rescue
        raise DecodeError, "content: <#{response.body}>"
      end

      organizations
    end

    def tidy_org(organization)
      organization.each_pair do |k, v|
        organization[k].strip! if v.class == String
      end
      organization
    end

    def raise_errors(response)
      raise(Timeout, "The Guidestar server could not be reached") if response.nil?

      case response.code
        when 500
          raise ServerError, "Guidestar server had an internal error. #{response.description}\n\n#{response.body}"
        when 502..503
          raise Unavailable, response.description
        else
          raise SemaphoreError, response.description
      end
    end

  end

end
