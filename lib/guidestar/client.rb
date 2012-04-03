module Guidestar

  class Client

    @@default_options = { :version => "1.0", :pageSize => 25, :offset => 0 }
    @@options_mapping = { :name => :orgName,
                          :zip_radius => :zipradius,
                          :ntee_code => :nteeCode,
                          :page_size => :pageSize
                        }

    @@connection = nil

    class << self

      def set_credentials(username, password, proxy=nil)
        @@connection = Connection.new(username, password, proxy)
      end

      def search(*args)
        options = extract_options!(args)
        options = translate_options(options)
        result = post(@@default_options.merge(options))
      end

    private

      def post(data)
        raise CredentialsNotSpecified if @@connection.nil?
        @@connection.post data
      end

      def decode_host(realm)
        realm.split('/').delete_if {|i| i == 'index.html' }.join('/').gsub(':5058', '')
      end

      def extract_options!(args)
        if args.last.is_a?(Hash)
          return args.pop
        else
          return {}
        end
      end

      def translate_options(options)
        dup_options = {}
        options.each_pair do |k,v|
          if @@options_mapping[k]
            dup_options[@@options_mapping[k]] = v
          else
            dup_options[k] = v
          end
        end

        # Ensure EINs are in the format NN-NNNNNNN
        dup_options[:ein].insert(2, '-') if dup_options[:ein] && dup_options[:ein][2] != '-'

        dup_options
      end

    end

  end

end
