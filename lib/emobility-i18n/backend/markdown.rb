require 'redcarpet'

module I18n
  module Backend
    module Markdown
      def translate(locale, key, options = {})
        markdown_renderer = options.delete(:markdown_renderer)
        markdown_options = options.delete(:markdown_options)

        result = super(locale, key, options)
        return result unless html_safe_translation_key?(key)

        markdown(markdown_renderer, markdown_options).render(result).strip
      end

      private

      def markdown(markdown_renderer, markdown_options)
        Redcarpet::Markdown.new(
          markdown_renderer || Redcarpet::Render::HTML,
          markdown_options || {}
        )
      end

      # Copied from Rails.
      # We assume that we can just render all HTML as Markdown. This has performance implications
      # since we might unnecessarily render plain HTML as Markdown. So let's keep an eye on it if
      # we reach a certain number of plain HTML translations.
      def html_safe_translation_key?(key)
        key.to_s =~ /(\b|_|\.)html$/
      end

    end
  end
end
