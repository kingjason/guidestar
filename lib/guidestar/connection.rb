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
        response = RestClient.post(ENDPOINT, :XML_INPUT => data, :multipart => true)
      rescue => e
        raise_errors(e.response)
      end

      response
    end

    def construct_document(data)
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.request(:version => data[:version]) {
          xml.document {
            xml.login @username
            xml.password @password
            xml.pageSize data[:pageSize]
            xml.offset data[:offset]
            xml.orgName data[:orgName] if data[:orgName]
          }
        }
      end

      builder.to_xml
    end

    def deconstruct_document(response)
      data = Array.new
      raise(Timeout, "The Guidestar server could not be reached") if response.nil?

      if !response.body.empty?
        # begin
        #   doc = Nokogiri::XML.parse(response)
        #   doc.xpath('//META').each do |node|
        #     if node['name'] == "Generic_ID"
        #       term = { :term_id => node['value'].to_i, :score => node['score'].to_f }
        #       data << term
        #     end
        #   end
        # rescue
        #   raise DecodeError, "content: <#{response.body}>"
        # end
      end

      response
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
