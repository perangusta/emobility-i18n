require 'spec_helper'

describe I18n::Backend::GlobalScope do
  class Backend < I18n::Backend::Simple
    include I18n::Backend::GlobalScope
  end

  before do
    I18n.backend = Backend.new
  end

  context 'when global scope is not given' do
    before do
      store_translations(:en, foo: 'foo', bar: { baz: 'baz' })
    end

    it 'still returns translations as usual' do
      expect(I18n.t('foo')).to eq 'foo'
      expect(I18n.t('bar.baz')).to eq 'baz'
    end
  end

  context 'when global scope is given' do
    let(:global_scope) { 'prefix' }

    before do
      I18n.global_scope = global_scope
    end

    context 'when scoped key does not exist' do
      before do
        store_translations(:en, foo: 'foo')
      end

      it 'returns translation for unscoped key' do
        expect(I18n.t('foo')).to eq 'foo'
      end
    end

    context 'when both scoped and not-scoped key exist' do
      before do
        store_translations(:en, prefix: { foo: 'prefixed_foo', bar: { baz: 'prefixed_baz' } }, foo: 'foo', bar: { baz: 'baz' })
      end

      it 'returns translation for scoped key' do
        expect(I18n.t('foo')).to eq 'prefixed_foo'
        expect(I18n.t('bar.baz')).to eq 'prefixed_baz'
      end
    end
  end
end
