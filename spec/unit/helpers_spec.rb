require 'spec_helper'

describe Middleman::Thumbnailer::Helpers do
  let(:options) do
    {
      dimensions: {
        small: 'x200',
        medium: 'x400'
      },
      include_data_thumbnails: false
    }
  end
  before do
    @helper = Object.new
    @helper.singleton_class.send :include, Padrino::Helpers
    @helper.singleton_class.send :include, Middleman::Thumbnailer::Helpers

    allow(Middleman::Thumbnailer).to receive(:options).and_return(options)
  end

  describe '.thumbnail' do
    it 'returns a html img tag for the requested dimension named' do
      img_tag = '<img src="/images/background-small-x200.jpg" />'
      expect(@helper.thumbnail('/images/background.jpg', :small)).to eq(img_tag)
      expect(@helper.thumbnail('/images/background.jpg', :medium)).not_to eq(img_tag)
    end

    context 'when include_data_thumbnails is disabled' do
      before do
        Middleman::Thumbnailer.options[:include_data_thumbnails] = false
      end

      it 'does not includes the data attribute' do
        expect(@helper.thumbnail('/images/background.jpg', :small)).not_to match('data-thumbnails')
      end
    end

    context 'when include_data_thumbnails is enabled' do
      before do
        Middleman::Thumbnailer.options[:include_data_thumbnails] = true
      end

      it 'includes the data attribute' do
        expect(@helper.thumbnail('/images/background.jpg', :small)).to match('data-thumbnails')
      end
    end
  end
end
