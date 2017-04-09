require 'spec_helper'

describe Middleman::Thumbnailer::Extension do
  let(:root)       { File.join(File.dirname(__FILE__), '../../fixtures/thumbnails') }
  let(:source_dir) { "#{root}/source" }
  let(:options) do
    double(namespace_directory: ['**'],
           filetypes: [:jpg, :jpeg, :png],
           dimensions: {
             small: 'x200'
           })
  end
  let(:app) { Middleman::Fixture.app }

  subject { Middleman::Thumbnailer::Extension.new(app) }

  before do
    allow(subject.app).to receive(:root).and_return(File.dirname(__FILE__))
    allow(subject.app).to receive(:source_dir).and_return('/SOURCE')
    allow(subject.app).to receive(:images_dir).and_return('/IMAGES')
    allow(subject.app).to receive(:sitemap)
  end

  describe '#after_configuration' do
    it 'is adds the rack middleware' do
      expect(subject.app).to receive(:use).with(Middleman::Thumbnailer::Rack, subject.options)
      subject.after_configuration
    end
  end

  describe '#manipulate_resource_list' do
    it 'adds a resource to the array for each thumbnail' do
      allow(subject).to receive(:thumbnails).and_return(
        double(assets: [
          double(paths: [{ name: :small, path: '/asset.png' }])
        ])
      )
      allow(Middleman::Sitemap::Resource).to receive(:new).and_return('Thumbnail')
      expect(subject.manipulate_resource_list([])).to eq(['Thumbnail'])
    end
  end

  describe '#thumbnails' do
    it 'returns an instance of Thumbnails' do
      expect(subject.thumbnails.class).to eq(Middleman::Thumbnailer::Thumbnails)
    end
  end

  describe 'before_build' do
    it 'calls build on thumbnails' do
      expect(subject.thumbnails).to receive(:build)
      subject.before_build
    end
  end
end
