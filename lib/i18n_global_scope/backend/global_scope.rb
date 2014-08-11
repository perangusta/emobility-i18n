module I18nGlobalScope
  module Backend
    module GlobalScope
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
    end
  end
end