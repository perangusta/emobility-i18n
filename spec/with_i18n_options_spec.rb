require 'spec_helper'

describe "Object#with_i18n_options" do
  subject { Object.new }

  context "when Object responds to with_options" do
    before do
      Object.class_eval { def with_options(options); 'foo'; end }
    end

    after do
      Object.class_eval { undef_method(:with_options) }
    end

    it "aliases Object#with_options" do
      expect(subject.with_i18n_options({})).to eq 'foo'
    end

    context "when I18n.default_options hash is set" do
      before do
        allow(I18n).to receive(:default_options).and_return(a: 1, b: 2)
      end

      context "when options passed" do
        it "adds passed options" do
          expect(subject).to receive(:with_options).with(a: 1, b: 2, c: 3)
          subject.with_i18n_options(c: 3)
        end

        it "overrides default_options with passed options" do
          expect(subject).to receive(:with_options).with(a: 10, b: 2, c: 3)
          subject.with_i18n_options(a: 10, c: 3)
        end
      end

      context "when options empty" do
        it "doesn't modify default_options" do
          expect(subject).to receive(:with_options).with(a: 1, b: 2)
          subject.with_i18n_options({})
        end
      end
    end

    context "when I18n.default_options hash is not set" do
      before do
        allow(I18n).to receive(:default_options).and_return(nil)
      end

      it "doesn't modify passed options" do
        expect(subject).to receive(:with_options).with(a: 1, b: 2)
        subject.with_i18n_options(a: 1, b: 2)
      end
    end
  end

  context "when Object doesn't respond to with_options" do
    before do
      Object.class_eval { undef_method(:with_options) if method_defined?(:with_options) }
    end

    it "raises a NoMethodError" do
      expect { Object.new.with_i18n_options({}) }.to raise_error(NoMethodError)
    end
  end

end
