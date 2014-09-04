module I18n
  module Backend
    class EMobility < Simple
      include GlobalScopePrefix, Cascade, KeyPrefix, Markdown
    end
  end
end
