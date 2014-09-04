module I18n
  module Backend
    module KeyPrefix
      def translate(locale, key, options = {})
        if key_prefix = options.delete(:key_prefix)
          separator = options[:separator] || I18n.default_separator

          # If the key contains a separator, we want to prepend the prefix only to the last key
          # part. This is so t(:foo, scope: :bar, key_prefix: baz) and
          # t(:'bar.foo', key_prefix: baz) do the same thing.
          parts = key.to_s.include?(separator) ?
                    I18n.normalize_keys(locale, key, options[:scope])[1..-1] :
                    [key]

          key = (parts[0..-2] + ["#{key_prefix}_#{parts[-1]}"]).join(separator)
        end

        super(locale, key, options)
      end
    end
  end
end
