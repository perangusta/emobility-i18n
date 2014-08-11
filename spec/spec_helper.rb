require 'bundler/setup'
Bundler.setup

require 'i18n_global_scope'
require 'helpers'

RSpec.configure do |config|
  config.include Helpers
end
