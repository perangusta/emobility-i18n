# I18nGlobalScope

This gem provides global scope for I18n keys with fallback if scoped key does not exist. 

You can think of it as reversed `I18n::Backend::Cascade` as it's removing parts from the begining of the key.

## Installation

Add this line to your application's Gemfile:

    gem 'i18n_global_scope', require: true

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install i18n_global_scope

## Usage

Create initializer file `i18n.rb` to introduce `GlobalScope` to `i18n`

    I18n::Backend::Simple.send(:include, I18n::Backend::GlobalScope)

After that you need to set `global_scope` just as you would set `default_locale`
 
    I18n.global_scope = 'some_scope'
    
If scoping by subdomain is the use case you can put something like this in the `application_controller.rb`

    class ApplicationController
      before_filter :set_global_scope
    
      private
      def set_global_scope
        I18n.global_scope = get_subdomain_from_url_here
      end
    end

## Contributing

1. Fork it ( http://github.com/<my-github-username>/i18n_global_scope/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
