require 'rubygems'
require 'rspec'
require 'mcollective'
require 'mcollective/test'
require 'rspec/mocks'
require 'mocha'
require 'tempfile'
require 'json'

RSpec.configure do |config|
    config.mock_with :mocha
    config.include(MCollective::Test::Matchers)
end
