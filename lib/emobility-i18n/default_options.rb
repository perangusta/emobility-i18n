module I18n
  class << self

    def default_options
      @default_options
    end

    def default_options=(options)
      @default_options = options
    end

    def merge_with_default_options(options)
      (default_options || {}).merge(options)
    end
  end
end
