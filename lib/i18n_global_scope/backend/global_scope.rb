module I18nGlobalScope
  module Backend
    module GlobalScope
      def lookup(locale, key, scope = [], options = {})
        return super if I18n.global_scope.nil?

        separator = options[:separator] || I18n.default_separator
        scope = [I18n.global_scope.to_sym] + I18n.normalize_keys(nil, key, scope, separator)
        key = (scope.slice!(-1,1) || []).join(separator)

        begin
          result = super
          return result unless result.nil?
          scope = scope.dup
        end while !scope.empty? && scope.shift
      end
    end
  end
end