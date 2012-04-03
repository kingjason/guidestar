require 'uri'
require 'nokogiri'
require 'rest_client'

require 'guidestar/connection'
require 'guidestar/client'

module Guidestar
  VERSION = File.read(File.join(File.dirname(__FILE__), '..', 'VERSION'))
  ENDPOINT = "https://gsservices.guidestar.org/GuideStar_SearchService/SearchService.asmx/GuideStarDetail"

  class GuidestarError < StandardError; end
  class InsufficientArgs < GuidestarError; end
  class Unauthorized < GuidestarError; end
  class NotFound < GuidestarError; end
  class ServerError < GuidestarError; end
  class Unavailable < GuidestarError; end
  class Timeout < GuidestarError; end
  class DecodeError < GuidestarError; end
  class CredentialsNotSpecified < GuidestarError; end
end
