require 'spec_helper'

describe Middleman::Thumbnailer::Thumbnails do
  let(:root)       { File.join(File.dirname(__FILE__), '../../fixtures/thumbnails') }
  let(:source_dir) { "#{root}/source" }
  let(:options) do
    double(namespace_directory: ['**'],
           filetypes: [:jpg, :jpeg, :png],
           dimensions: {
             small: 'x200'
           })
  end
  let(:app) { double(source_dir: source_dir, build_dir: 'build', root: root) }
  let(:extension) do
    double('Middleman::Thumbnailer::Extension', options: options, app: app)
  end

  subject { Middleman::Thumbnailer::Thumbnails.new(extension, source_dir + '/images') }

  describe '#filetypes_with_capitals' do
    it 'returns an array with the filetypes capitalized' do
      expect(subject.filetypes_with_capitals).to eq([:jpg, :JPG, :jpeg, :JPEG, :png, :PNG])
    end
  end

  describe '#root' do
    it 'returns the root from the app' do
      expect(subject.root).to eq(root)
    end
  end

  describe '#glob' do
    it 'returns a glob for the directory with namespaces and filetypes' do
      expect(subject.glob).to match(%r(source\/images\/\*\*\/\*\.{jpg,JPG,jpeg,JPEG,png,PNG}$))
    end
  end

  describe '#assets' do
    it 'returns an array of Assets' do
      expect(subject.assets[0].class).to eq(Middleman::Thumbnailer::Asset)
    end
  end

  describe '#build' do
    it 'calls build on each asset' do
      expect(subject.assets).to receive(:each)
      subject.build
    end
  end
end
