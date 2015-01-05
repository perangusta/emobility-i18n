shared_examples_for 'a cascading backend' do
  it "doesn't cascade when cascading is explicitly disabled" do
    expect { I18n.t('the_application.the_brand.title', i18n_options.merge(cascade: false, raise: true)) }.to raise_error(I18n::MissingTranslationData)
  end

  context "without a global scope prefix" do
    it "finds keys without cascading" do
      # deeply  nested
      expect(I18n.t('the_application.the_brand.start_page_heading', i18n_options)).to eq 'The Heading'
      expect(I18n.t('the_application.the_brand.name', i18n_options)).to eq 'The Brand'

      # nested
      expect(I18n.t('the_application.title', i18n_options)).to eq 'The Application'
      expect(I18n.t('the_application.start_page_title', i18n_options)).to eq 'The Start Page'

      # top level
      expect(I18n.t('create', i18n_options)).to eq 'Create'
      expect(I18n.t('start_page_create', i18n_options)).to eq 'Create from Start Page'
    end

    it "finds keys with cascading" do
      # nested
      expect(I18n.t('the_application.the_brand.title', i18n_options)).to eq 'The Application'
      expect(I18n.t('the_application.the_brand.start_page_title', i18n_options)).to eq 'The Start Page'

      # top level
      expect(I18n.t('the_application.create', i18n_options)).to eq 'Create'
      expect(I18n.t('the_application.start_page_create', i18n_options)).to eq 'Create from Start Page'
    end
  end

  context "with a global scope prefix" do
    before { I18n.global_scope_prefix = 'the_application.the_brand' }

    it "finds keys without cascading" do
      # deeply nested
      expect(I18n.t('start_page_heading', i18n_options)).to eq 'The Heading'
      expect(I18n.t('name', i18n_options)).to eq 'The Brand'
    end

    it "finds keys with cascading" do
      # nested
      expect(I18n.t('title', i18n_options)).to eq 'The Application'
      expect(I18n.t('start_page_title', i18n_options)).to eq 'The Start Page'

      # top level
      expect(I18n.t('create', i18n_options)).to eq 'Create'
      expect(I18n.t('start_page_create', i18n_options)).to eq 'Create from Start Page'
    end

    it "still finds scoped keys" do
      expect(I18n.t('the_application.the_brand.name', i18n_options)).to eq 'The Brand'
      expect(I18n.t('the_application.the_brand.start_page_heading', i18n_options)).to eq 'The Heading'
      expect(I18n.t('the_application.title', i18n_options)).to eq 'The Application'
      expect(I18n.t('the_application.start_page_title', i18n_options)).to eq 'The Start Page'
    end

    it "finds scoped keys outside the global scope prefix when given the proper :cascade option" do
      expect(I18n.t('somewhere.over_the_rainbow', i18n_options.merge(cascade: { offset: 2 }))).to eq 'way up high'
    end

    context "with a manual :scope_prefix" do
      it "finds keys" do
        expect(I18n.t('over_the_rainbow', i18n_options.merge(scope_prefix: 'somewhere'))).to eq 'way up high'
      end

      it "finds keys with the scope prefix manually disabled" do
        expect(I18n.t('somewhere.over_the_rainbow', i18n_options.merge(scope_prefix: false))).to eq 'way up high'
      end
    end
  end

  context "with a key prefix" do
    let(:i18n_options) { super().merge(key_prefix: 'start_page') }

    it "finds keys without cascading" do
      expect(I18n.t('the_application.the_brand.heading', i18n_options)).to eq 'The Heading'
      expect(I18n.t('the_application.title', i18n_options)).to eq 'The Start Page'
      expect(I18n.t('create', i18n_options)).to eq 'Create from Start Page'
    end

    it "finds keys with cascading" do
      expect(I18n.t('the_application.the_brand.title', i18n_options)).to eq 'The Start Page'
      expect(I18n.t('the_application.the_brand.create', i18n_options)).to eq 'Create from Start Page'
    end
  end
end