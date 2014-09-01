# EMobility i18n

This gem provides some i18n functionality for the eMobility project.

## Features

### Global Scope

The `GlobalScope` module allows for i18n keys with fallback if scoped key does not exist.

You can think of this as a reversed version of `I18n::Backend::Cascade` as it's removing parts from the begining of the key.

## Installation

Add this line to your application's Gemfile:

    gem 'emobility-i18n', github: 'mobilityhouse/emobility-i18n'

And then execute:

    $ bundle

## Usage

### Global Scope

Create an initializer file `config/initializers/i18n.rb` and include the `GlobalScope` module into your i18n backend:

    I18n::Backend::Simple.send(:include, I18n::Backend::GlobalScope)

After that you need to set `global_scope` just as you would set `default_locale`:
 
    I18n.global_scope = 'some_scope'
    
If you want to scope by subdomain, you can put something like this in `app/controllers/application_controller.rb`

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
