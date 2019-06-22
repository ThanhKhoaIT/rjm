require 'open-uri'

require "rjm/version"
require "rjm/js_processor"
require "rjm/js_fetcher"

module Rjm

  class Error < StandardError; end
  class Engine < Rails::Engine; end

end
