module I18n
  module Backend
    module GlobalScopePrefix
      def self.included(base)
        I18n::Config.send(:include, ConfigExtension)
        I18n.extend(CoreExtension)
      end

      def lookup(locale, key, scope = [], options = {})
        return super if I18n.global_scope_prefix.nil?

        separator = options[:separator] || I18n.default_separator
        scope = I18n.normalize_keys(nil, scope, I18n.global_scope_prefix, separator)

        super
      end

      module ConfigExtension
        def global_scope_prefix
          @global_scope_prefix
        end

        def global_scope_prefix=(scope_prefix)
          @global_scope_prefix = scope_prefix
        end
      end

      module CoreExtension
        def global_scope_prefix
          config.global_scope_prefix
        end

        def global_scope_prefix=(scope_prefix)
          config.global_scope_prefix = scope_prefix
        end
      end
    end
  end
end
