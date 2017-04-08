lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'simplecov'

SimpleCov.start do
  add_filter 'spec'
end

require 'middleman'
require 'middleman-thumbnailer'
require_relative 'support/fixture'

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.allow_message_expectations_on_nil = true
  end
end
