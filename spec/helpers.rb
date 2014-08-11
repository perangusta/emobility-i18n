module Helpers
  def store_translations(locale, data)
    I18n.backend.store_translations(locale, data)
  end
end