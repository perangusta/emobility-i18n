require 'spec_helper'

describe "Object#with_i18n_options" do
  context "when Object responds to with_options" do
    before do
      Object.class_eval { def with_options(options); 'foo'; end }
    end

    after do
      Object.class_eval { undef_method(:with_options) }
    end

    it "aliases Object#with_options" do
      expect(Object.new.with_i18n_options({})).to eq 'foo'
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
