require 'spec_helper'

describe I18n::Backend::GlobalScopePrefix do
  class GlobalScopePrefixBackend < I18n::Backend::Simple
    include I18n::Backend::GlobalScopePrefix
  end

  before do
    I18n.backend = GlobalScopePrefixBackend.new
  end

  context "when no global scope prefix is given" do
    before do
      store_translations(:en, foo: 'foo', bar: { baz: 'baz' })
    end

    it "finds translations as usual" do
      expect(I18n.t('foo')).to eq 'foo'
      expect(I18n.t('bar.baz')).to eq 'baz'
    end
  end

  context "when global scope prefix is given" do
    let(:prefix) { 'prefix' }

    before do
      I18n.global_scope_prefix = prefix
    end

    context "when scoped key does not exist" do
      before do
        store_translations(:en, foo: 'foo')
      end

      it "doesn't find an unscoped translation" do
        expect { I18n.t('foo', raise: true) }.to raise_error(I18n::MissingTranslationData)
      end
    end

    context 'when a scoped translation exists' do
      before do
        store_translations(:en, prefix => { foo: 'prefixed_foo', bar: { baz: 'prefixed_baz' } })
      end

      it "finds a scoped translation" do
        expect(I18n.t('foo')).to eq 'prefixed_foo'
      end

      it "finds a nested scoped translation" do
        expect(I18n.t('bar.baz')).to eq 'prefixed_baz'
      end
    end

    describe "cascade" do
      class GlobalScopePrefixCascadeBackend < I18n::Backend::Simple
        include I18n::Backend::GlobalScopePrefix, I18n::Backend::Cascade
      end

      context "when the global scope contains the scope separator" do
        before do
          I18n.backend = GlobalScopePrefixCascadeBackend.new
          I18n.global_scope_prefix = 'foo.bar'
          store_translations(:en, foo: { bar: { bam: 'bam' }, baz: 'baz' }, buz: 'buz')
        end

        it "cascades properly" do
          expect(I18n.t('bam', cascade: true)).to eq 'bam'
          expect(I18n.t('baz', cascade: true)).to eq 'baz'
          expect(I18n.t('buz', cascade: true)).to eq 'buz'
        end
      end
    end
  end
end
