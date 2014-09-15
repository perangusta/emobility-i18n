module I18n
  module Backend
    class EMobility < Simple
      include GlobalScopePrefix, KeyPrefix, Metadata, Markdown, Cascade, Fallbacks

      def translate(locale, key, options = {})
        options.merge!(cascade: true) unless options.key?(:cascade)
        super
      end
    end
  end
end
