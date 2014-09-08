require 'bundler/setup'
Bundler.setup

require 'emobility-i18n'
require 'helpers'

RSpec.configure do |config|
  config.include Helpers

  config.before do
    I18n.default_locale = :en
    I18n.locale = nil
  end

  config.after do
    I18n.global_scope_prefix = nil
    I18n.global_scope = nil
  end
end
