module I18n
  module Backend
    module GlobalScopePrefix
      def self.included(base)
        I18n::Config.send(:include, ConfigExtension)
        I18n.extend(CoreExtension)
      end

      def translate(locale, key, options = {})
        # If we manually pass a :scope_prefix, we use this. Otherwise we use the
        # configured global_scope_prefix.
        scope_prefix = options.key?(:scope_prefix) ? options[:scope_prefix] : I18n.global_scope_prefix
        return super unless scope_prefix

        separator = options[:separator] || I18n.default_separator
        options[:scope] = I18n.normalize_keys(nil, options[:scope], scope_prefix, separator)

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
