module I18n
  module Backend
    module GlobalScope
      def self.included(base)
        I18n::Config.send(:include, ConfigExtension)
        I18n.extend(CoreExtension)
      end

      def lookup(locale, key, scope = [], options = {})
        return super if I18n.global_scope.nil?

        separator = options[:separator] || I18n.default_separator
        scope = [I18n.global_scope.to_sym] + I18n.normalize_keys(nil, key, scope, separator)
        key = (scope.slice!(-1,1) || []).join(separator)

        result = super
        unless result.nil?
          result
        else
          scope = scope.dup
          scope.shift
          super
        end
      end

      module ConfigExtension
        def global_scope
          @global_scope
        end

        def global_scope=(scope)
          @global_scope = scope
        end
      end

      module CoreExtension
        def global_scope
          config.global_scope
        end

        def global_scope=(scope)
          config.global_scope = scope
        end
      end
    end
  end
end
