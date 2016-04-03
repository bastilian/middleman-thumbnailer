require 'spec_helper'

describe Middleman::Thumbnailer::Asset do
  let(:root)       { File.join(File.dirname(__FILE__), '../../fixtures/thumbnails') }
  let(:source_dir) { "#{root}/source" }
  let(:directory)  { "#{source_dir}/images" }
  let(:file)       { File.new("#{directory}/background.png") }
  let(:filename)   { "#{subject.file_name}-small-#{options.dimensions[:small]}.png" }

  let(:options) do
    double(namespace_directory: ['**'],
           filetypes: [:jpg, :jpeg, :png],
           dimensions: {
             small: 'x200'
           })
  end
  let(:app) { double(source_dir: source_dir, build_dir: 'build') }
  let(:extension) do
    double('Middleman::Thumbnailer::Extension', options: options, app: app)
  end
  let(:collection) do
    double('Middleman::Thumbnailer::Thumbnails',
           extension: extension,
           directory: directory,
           options: options,
           root: root)
  end

  subject { Middleman::Thumbnailer::Asset.new(collection, file) }

  describe '#image' do
    it 'is a rmagick image' do
      expect(subject.image.class).to eq(Magick::Image)
    end
  end

  describe '#directory' do
    it 'returns the file\'s dirname' do
      expect(subject.directory).to eq(File.dirname(subject.file))
    end
  end

  describe '#relative_directory' do
    let(:relative_dir) { directory.gsub(source_dir, '')[1..-1] }

    it 'returns the directory relative to the source path' do
      expect(subject.relative_directory).to eq(relative_dir)
    end
  end

  describe '#specs' do
    it 'returns a hash' do
      expect(subject.specs.class).to eq(Hash)
    end
    it 'contains the original' do
      expect(subject.specs[:original][:name]).to eq(File.basename(subject.file))
    end
    it 'contains the small format' do
      expect(subject.specs[:small][:name]).to eq(filename)
    end
    it 'contains the small dimensions' do
      expect(subject.specs[:small][:dimensions]).to eq(options.dimensions[:small])
    end
  end

  describe '#paths' do
    let(:dimensions_key) { "#{subject.relative_directory}/#{filename}" }

    it 'returns a hash' do
      expect(subject.paths.class).to eq(Hash)
    end
    it 'contains the relative path and the spec name as hash keys' do
      expect(subject.paths[dimensions_key]).to_not be(nil)
    end
    it 'has the full file path as values' do
      expect(subject.paths[dimensions_key]).to eq(File.join(subject.build_directory, filename))
    end
  end

  describe '#build' do
    after do
      FileUtils.rm_rf("#{root}/build")
    end

    context 'when the build directory does not exist' do
      it 'calls mkdir_p' do
        allow(subject.image).to receive(:change_geometry).and_return(true)
        allow(Dir).to receive(:exist?).and_return(false)

        expect(FileUtils).to receive(:mkdir_p)
        subject.build
      end
    end

    it 'calls change_geometry on the image' do
      expect(subject.image).to receive(:change_geometry)
      subject.build
    end
    it 'writes the image when calling change_geometry' do
      expect_any_instance_of(Magick::Image).to receive(:write)
      subject.build
    end
  end
end
