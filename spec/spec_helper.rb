require 'bundler/setup'
Bundler.setup

require 'emobility-i18n'
require 'helpers'

RSpec.configure do |config|
  config.include Helpers
end
