require 'spec_helper'

describe I18n::Backend::GlobalScope do
  class GlobalScopeBackend < I18n::Backend::Simple
    include I18n::Backend::GlobalScope
  end

  before do
    I18n.backend = GlobalScopeBackend.new
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
        store_translations(:en, global_scope => { foo: 'prefixed_foo', bar: { baz: 'prefixed_baz' } }, foo: 'foo', bar: { baz: 'baz' })
      end

      it 'returns translation for scoped key' do
        expect(I18n.t('foo')).to eq 'prefixed_foo'
        expect(I18n.t('bar.baz')).to eq 'prefixed_baz'
      end
    end
  end

  context 'when global scope array is given' do
    let(:global_scope) { ['first_prefix', 'second_prefix'] }

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

    context 'when both first scoped and not-scoped key exist' do
      before do
        store_translations(:en, global_scope[0] => { foo: 'prefixed_foo', bar: { baz: 'prefixed_baz' } },
                                foo: 'foo',
                                bar: { baz: 'baz' })
      end

      it 'returns translation for the first scoped key' do
        expect(I18n.t('foo')).to eq 'prefixed_foo'
        expect(I18n.t('bar.baz')).to eq 'prefixed_baz'
      end
    end

    context 'when both second scoped and not-scoped key exist' do
      before do
        store_translations(:en, global_scope[1] => { foo: 'prefixed_foo', bar: { baz: 'prefixed_baz' } },
                                foo: 'foo',
                                bar: { baz: 'baz' })
      end

      it 'returns translation for second scoped key' do
        expect(I18n.t('foo')).to eq 'prefixed_foo'
        expect(I18n.t('bar.baz')).to eq 'prefixed_baz'
      end
    end
    context 'when both first and second scoped and not-scoped key exist' do
      before do
        store_translations(:en, global_scope[0] => { foo: 'first_prefixed_foo', bar: { baz: 'first_prefixed_baz' } },
                                global_scope[1] => { foo: 'prefixed_foo', bar: { baz: 'prefixed_baz' } },
                                foo: 'foo',
                                bar: { baz: 'baz' })
      end

      it 'returns translation for first scoped key' do
        expect(I18n.t('foo')).to eq 'first_prefixed_foo'
        expect(I18n.t('bar.baz')).to eq 'first_prefixed_baz'
      end
    end
  end
end
