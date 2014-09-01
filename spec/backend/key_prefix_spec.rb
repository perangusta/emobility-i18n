require 'spec_helper'

describe I18n::Backend::KeyPrefix do
  class Backend < I18n::Backend::Simple
    include I18n::Backend::KeyPrefix
  end

  before do
    I18n.backend = Backend.new

    store_translations(:en, prefixed_foo: 'foo', bar: { prefixed_bar: 'bar' })
  end

  it "prepends a given prefix" do
    expect(I18n.translate(:foo, key_prefix: :prefixed)).to eq 'foo'
  end

  it "prepends a given prefix to a nested key" do
    expect(I18n.translate(:'bar.bar', key_prefix: :prefixed)).to eq 'bar'
  end

  it "prepends a given prefix to a nested key" do
    expect(I18n.translate(:bar, scope: :bar, key_prefix: :prefixed)).to eq 'bar'
  end
end
