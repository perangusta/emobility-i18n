# This assumes that you're using ActiveSupport's Object#with_options (http://apidock.com/rails/Object/with_options).
# If the method isn't available (= if you're not using ActiveSupport, you'll just get a
# NoMethodError.

class Object
  def with_i18n_options(*args, &block)
    with_options(*args, &block)
  end
end
