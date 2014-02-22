# require 'spec_helper'
require 'middleman-thumbnailer'

require "middleman-thumbnailer/thumbnail-generator"

describe ::Middleman::ThumbnailGenerator do
  let(:klass) { Middleman::ThumbnailGenerator }
  let(:filename) {'test.jpg'}
  describe "#specs" do

    # it "should always return the original filename in :original" do 
    #   dimensions = {:small => '100x100'}
    #   klass.generate(filename, dimensions).should include(:original => filename)
    # end

    # it "should always return the original filename in :original" do 
    #   dimensions = {:small => '100x100'}
    #   klass.generate(filename, dimensions).should include(:small => 'test-small-100x100.jpg')
    # end
  end

end