require 'open-uri'
require 'rack/mime'

require "rjm/version"
require "rjm/fetchers"
require "rjm/fetchers/js"
require "rjm/fetchers/css"
require "rjm/fetchers/json"
require "rjm/js_processor"
require "rjm/css_processor"

module Rjm

  class Error < StandardError; end
  class Engine < Rails::Engine; end

end
