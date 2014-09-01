module I18n
  module Backend
    class EMobility < Simple
      include GlobalScope, KeyPrefix, Markdown
    end
  end
end
