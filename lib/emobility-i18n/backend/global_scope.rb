module I18n
  module Backend
    module GlobalScope
      def self.included(base)
        I18n::Config.send(:include, ConfigExtension)
        I18n.extend(CoreExtension)
      end

      def lookup(locale, key, scope = [], options = {})
        return super if I18n.global_scope.nil?

        global_scopes = Array(I18n.global_scope)
        separator     = options[:separator] || I18n.default_separator
        scope         = I18n.normalize_keys(nil, nil, scope, separator)
        result        = nil

        until result || global_scopes.empty?
          scope.unshift(global_scopes.first.to_sym)

          result = super
          next if result

          scope = scope.dup
          scope.shift
          global_scopes.shift
        end

        result || super
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
