require 'spec_helper'

describe "default_options" do

  context "when I18n.default_options hash is set" do
    before do
      allow(I18n).to receive(:default_options).and_return(a: 1, b: 2)
    end

    context "when options passed" do
      it "adds passed options" do
        expect(I18n.merge_with_default_options(c: 3)).to eq({ a: 1, b: 2, c: 3 })
      end

      it "overrides default_options with passed options" do
        expect(I18n.merge_with_default_options(a: 10, c: 3)).to eq({ a: 10, b: 2, c: 3 })
      end
    end

    context "when options empty" do
      it "doesn't modify default_options" do
        expect(I18n.merge_with_default_options({})).to eq({ a: 1, b: 2 })
      end
    end
  end

  context "when I18n.default_options hash is not set" do
    before do
      allow(I18n).to receive(:default_options).and_return(nil)
    end

    it "doesn't modify passed options" do
      expect(I18n.merge_with_default_options(a: 1, b: 2)).to eq({ a: 1, b: 2 })
    end
  end
end
