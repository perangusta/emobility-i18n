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
end
