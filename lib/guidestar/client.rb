module Guidestar

  class Client

    @@default_options = { :version => "1.0", :pageSize => 25, :offset => 0 }

    @@connection = nil

    class << self

      def set_credentials(username, password, proxy=nil)
        @@connection = Connection.new(username, password, proxy)
      end

      def search_by_org_name(org_name)
        options = { :orgName => org_name }
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

    end

  end

end
