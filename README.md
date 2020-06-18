# Per Angusta Fork
This is a fork adapted for the special use of Per Angusta.

# EMobility i18n

This gem provides some i18n functionality for the eMobility project.

## Features

### Object#with_i18n_options

This is just an alias to Rails' `[Object#with_options](http://apidock.com/rails/Object/with_options)`. The alias is just there to better carry the intent.

### Global Scope

The `GlobalScope` module allows for i18n keys with fallback if scoped key does not exist.

You can think of this as a reversed version of `I18n::Backend::Cascade` as it's removing parts from the begining of the key.

### Global Scope Prefix

The `GlobalScopePrefix` module is similar to the `GlobalScope` module but just prepends a scope to **every key** that gets translated without the "reverse cascade".

### Key Prefix

The `KeyPrefix` module allows to pass a key prefix to i18n lookups. We use this together with `GlobalScope` to facilitate proper cascades without deeply nesting translations while still allowing for easy scoping/grouping translations for developers. See usage example below.

### Markdown

Using Markdown should be simple and we shouldn't have to mark strings as `html_safe` all the time. Therefore we're piggybacking on Rails' `TranslationHelper` and use the `html` suffix as a hint that we might have Markdown text stored at that key.

We might not only use this in views which is why it's implemented directly on the backend.

## Installation

Add this line to your application's Gemfile:

    gem 'emobility-i18n', github: 'mobilityhouse/emobility-i18n'

And then execute:

    $ bundle

## Usage

### with_i18n_options

``` slim
- with_i18n_options(scope: 'admin.users.form') do |i18n|
  / This will set the submit button label to the translation at 'admin.users.form.create'
  = f.submit i18n.t(:create)
```

### Global Scope

Create an initializer file `config/initializers/i18n.rb` and include the `GlobalScope` module into your i18n backend:

``` ruby
I18n::Backend::Simple.send(:include, I18n::Backend::GlobalScope)
```

After that you need to set `global_scope` just as you would set `default_locale`:

``` ruby
I18n.global_scope = 'some_scope'
```

If you want to scope by subdomain, you can put something like this in `app/controllers/application_controller.rb`:

``` ruby
class ApplicationController
  before_filter :set_global_scope

  private

  def set_global_scope
    I18n.global_scope = get_subdomain_from_url_here
  end
end
```

Note: If you want to use global_scope fallbacks, you have to use Array format as follows

``` ruby
I18n.global_scope = %w[some scope]

t('foo') # => looks for 'some.foo' and then 'scope.foo' and finally 'foo'
```
You can use scopes containing other scopes within the array form of global_scope too but the whole scope gets chopped off! Same as below:

``` ruby
I18n.global_scope = 'some.scope'
t('foo') # => looks for 'some.scope.foo' and then 'foo' but never 'scope.foo' nor 'some.foo'
```

### Global Scope Prefix

Create an initializer file `config/initializers/i18n.rb` and include the `GlobalScopePrefix` module into your i18n backend:

``` ruby
I18n::Backend::Simple.send(:include, I18n::Backend::GlobalScopePrefix)
```

After that you need to set `global_scope_prefix` just as you would set `default_locale`:

``` ruby
I18n.global_scope_prefix = 'some_scope' # this can also be a scope containing scopes, e.g. "some.scope"
```

Subsequent calls to `I18n.translate` will prepend the scope to every call:

``` ruby
t('foo')                # => returns the translation at 'some.scope.foo'
t('foo', cascade: true) # => works as expected and looks for 'some.scope.foo', 'some.foo' and 'foo' (in that order)
```

You can use this to scope by subdomain like you can use `global_scope` (see above).

Caveat: If you want to use this with I18n's `Cascade` module, note that **module inclusion order matters**. See our `EMobility` backend for how to do this correctly and note that the order might be different if you're including modules separately (blame Ruby's `include` mechanism for it).

### Key Prefix

``` ruby
I18n::Backend::Simple.send(:include, I18n::Backend::KeyPrefix)

# classic approach
t('admin.some-brand.users.form.create', cascade: true) # resulting cascade: admin.some-brand.users.form.create, admin.some-brand.users.create, admin.some-brand.create, admin.create, create

# manual key prefix
t('admin.some-brand.users_form_create', cascade: true) # resulting cascade: admin.some-brand.users_form_create, admin.users_form_create, users_form_create

# with the module
t('admin.some-brand.create', key_prefix: 'users_form', cascade: true) # resulting cascade: same as above
```

The benefit becomes visible when you're using our `with_18n_options`-based approach in views:

``` slim
/ assuming I18n.global_scope = 'some-brand' was set in some controller
- with_i18n_options(scope: 'admin', key_prefix: 'users_form') do |i18n|
  / this automatically does the whole cascade from above
  = f.submit i18n.t(:create)
```

### Markdown

``` ruby
I18n::Backend::Simple.send(:include, I18n::Backend::Markdown)

t('some_text_html') # => will render the translation at the given key as Markdown
t('some_key.html')  # => same
```

### One Backend to Rule Them All

Use the `I18n::Backend::EMobility` backend to included **all of the aforementioned features except GlobalScope as well as i18n's own Cascade and Fallback modules**. It's just an extension of the `Simple` backend that ships with i18n with the features we need in our application.

``` ruby
I18n.backend = I18n::Backend::EMobility.new
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/emobility-i18n/fork )
2. Create your feature branch (`git checkout -b feature/name_your_feature`)
3. Run tests locally, all examples should be green (`rspec`)
4. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin feature/name_your_feature`)
7. Create new Pull Request
