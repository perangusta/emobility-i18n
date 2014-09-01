# EMobility i18n

This gem provides some i18n functionality for the eMobility project.

## Features

### Object#with_i18n_options

This is just an alias to Rails' `[Object#with_options](http://apidock.com/rails/Object/with_options)`. The alias is just there to better carry the intent.

### Global Scope

The `GlobalScope` module allows for i18n keys with fallback if scoped key does not exist.

You can think of this as a reversed version of `I18n::Backend::Cascade` as it's removing parts from the begining of the key.

### Key Prefix

The `KeyPrefix` module allows to pass a key prefix to i18n lookups. We use this together with `GlobalScope` to facilitate proper cascades without deeply nesting translations while still allowing for easy scoping/grouping translations for developers:

Consider this:

```
# classic approach
t('admin.some-brand.users.form.create', cascade: true) # resulting cascade: admin.some-brand.users.form.create, admin.some-brand.users.create, admin.some-brand.create, admin.create, create

# manual key prefix
t('admin.some-brand.users_form_create', cascade: true) # resulting cascade: admin.some-brand.users_form_create, admin.users_form_create, users_form_create

# with the module
t('admin.some-brand.create', key_prefix: 'users_form', cascade: true) # resulting cascade: same as above
```

The benefit becomes visible when you're using our `with_18n_options`-based approach in views:

```
/ assuming I18n.global_scope = 'some-brand' was set in some controller
- with_i18n_options(scope: 'admin', key_prefix: 'users_form') do |i18n|
  / this automatically does the whole cascade from above
  = f.submit i18n.t(:create)
```

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
