module I18n
  module Backend
    module KeyPrefix
      def translate(locale, key, options = {})
        if key_prefix = options.delete(:key_prefix)
          # If the key contains a separator, we want to prepend the prefix only to the last key
          # part. This is so t(:foo, scope: :bar) and t(:'bar.foo') do the same thing.
          parts = key.to_s.include?(I18n.default_separator) ?
                    I18n.normalize_keys(locale, key, options[:scope])[1..-1] :
                    [key]

          key = (parts[0..-2] + ["#{key_prefix}_#{parts[-1]}"]).join(I18n.default_separator)
        end

        super(locale, key, options)
      end
    end
  end
end
