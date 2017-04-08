PROJECT_ROOT_PATH = File.dirname(File.dirname(File.dirname(__FILE__)))

ENV['TEST'] = 'true'
ENV["AUTOLOAD_SPROCKETS"] = "true"

require 'simplecov'
SimpleCov.start do
  add_filter "/features/"
end

require "middleman-core"
require "middleman-core/step_definitions"

require File.join(PROJECT_ROOT_PATH, 'lib', 'middleman-thumbnailer')
