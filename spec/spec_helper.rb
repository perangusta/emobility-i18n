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
    I18n.global_scope_prefix = nil if I18n.respond_to?(:global_scope_prefix=)
    I18n.global_scope = nil        if I18n.respond_to?(:global_scope=)
  end
end
