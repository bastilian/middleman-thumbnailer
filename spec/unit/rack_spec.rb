require 'spec_helper'

describe Middleman::Thumbnailer::Rack do
  let(:root)              { File.join(File.dirname(__FILE__), '../../fixtures/site') }
  let(:source_dir)        { "#{root}/source" }
  let(:images_source_dir) { "#{source_dir}/images" }
  let(:app)               { proc { [200, {}, ['']] } }
  let(:options) do
    {
      namespace_directory: ['**'],
      filetypes: [:jpg, :jpeg, :png],
      source_dir: source_dir,
      images_source_dir: images_source_dir,
      root: root,
      dimensions: {
        small: 'x200'
      }
    }
  end

  subject { Middleman::Thumbnailer::Rack.new(app, options) }

  before do
    allow(options).to receive(:root).and_return(options[:root])
  end

  describe '#call' do
    let(:env) { { 'PATH_INFO' => '/images/background-small-x200.png' } }

    it 'returns an Array' do
      expect(subject.call(env).class).to eq(Array)
    end

    context 'when an image is available' do
      it 'returns a 200' do
        expect(subject.call(env)[0]).to eq(200)
      end
      it 'contains a Content-Type' do
        expect(subject.call(env)[1]['Content-Type']).to_not be(nil)
      end

      it 'has a Content-Length greater then 0' do
        expect(subject.call(env)[1]['Content-Length'].to_i).to be > 0
      end
    end

    context 'when an image is not available' do
      let(:env) { { 'PATH_INFO' => '/images/not-available.png' } }

      it 'returns a 200' do
        expect(subject.call(env)[0]).to eq(200)
      end
      it 'returns the default empty response' do
        expect(subject.call(env)[2]).to eq([''])
      end
    end
  end
end
