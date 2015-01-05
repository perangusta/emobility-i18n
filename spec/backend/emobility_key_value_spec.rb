require 'spec_helper'

describe I18n::Backend::EMobilityKeyValue do
  let(:i18n_options) { {} }

  before do
    I18n.backend = described_class.new(Redis.new)

    store_translations(:en,
                       the_application: {
                           title: 'The Application',
                           start_page_title: 'The Start Page',
                           the_brand: {
                               start_page_heading: 'The Heading',
                               name: 'The Brand'
                           }
                       },
                       create: 'Create',
                       start_page_create: 'Create from Start Page',
                       somewhere: {
                           over_the_rainbow: 'way up high'
                       }
    )

    I18n.locale = :'en-GB'
  end

  describe "cascading" do
    it_behaves_like 'a cascading backend'
  end

  describe "cascading and fallbacks" do
    before { I18n.fallbacks = I18n::Locale::Fallbacks.new(:de => :en) }

    context "with a country-specific language" do
      before { I18n.locale = :'de-DE' }

      it_behaves_like 'a cascading backend'
    end

    context "with just a language" do
      before { I18n.locale = :de }

      it_behaves_like 'a cascading backend'
    end
  end
end