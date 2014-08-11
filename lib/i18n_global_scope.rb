require 'i18n'

module I18n
  class Config
    def global_scope
      @global_scope
    end

    def global_scope=(scope)
      @global_scope = scope
    end
  end
end

module I18n
  extend Module.new {
    def global_scope
      config.global_scope
    end

    def global_scope=(value)
      config.global_scope = value
    end
  }
end

require 'i18n_global_scope/backend/global_scope'
