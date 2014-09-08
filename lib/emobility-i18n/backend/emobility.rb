module I18n
  module Backend
    class EMobility < Simple
      include GlobalScopePrefix, KeyPrefix, Markdown, Cascade, Fallbacks

      def translate(locale, key, options = {})
        options.merge!(cascade: true) unless options[:cascade] === false
        super
      end
    end
  end
end
