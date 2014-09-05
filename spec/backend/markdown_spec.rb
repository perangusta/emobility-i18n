require 'spec_helper'

describe I18n::Backend::Markdown do
  class Backend < I18n::Backend::Simple
    include I18n::Backend::Markdown
  end

  before do
    I18n.backend = Backend.new

    store_translations(:en, not_markdown: '**foo**', markdown_html: '**bar**')
  end

  it "renders Markdown" do
    expect(I18n.translate(:markdown_html)).to eq '<p><strong>bar</strong></p>'
  end

  it "doesn't render Markdown for non-HTML keys" do
    expect(I18n.translate(:not_markdown)).to eq '**foo**'
  end

  context "when I18n.default_options hash is set" do
    before do
      allow(I18n).to receive(:default_options).and_return(a: 1, b: 2)
    end

    context "when options passed" do
      it "adds passed options" do
        expect(I18n).to receive(:merge_with_default_options).and_return(a: 1, b: 2, c: 3)
        I18n.translate(:not_markdown, c: 3)
      end

      it "overrides default_options with passed options" do
        expect(I18n).to receive(:merge_with_default_options).and_return(a: 10, b: 2, c: 3)
        I18n.translate(:not_markdown, a: 10, c: 3)
      end
    end

    context "when options empty" do
      it "doesn't modify default_options" do
        expect(I18n).to receive(:merge_with_default_options).and_return(a: 1, b: 2)
        I18n.translate(:not_markdown)
      end
    end
  end

  context "when I18n.default_options hash is not set" do
    before do
      allow(I18n).to receive(:default_options).and_return(nil)
    end

    it "doesn't modify passed options" do
      expect(I18n).to receive(:merge_with_default_options).and_return(a: 1, b: 2)
      I18n.translate(:not_markdown, a: 1, b: 2)
    end
  end
end
