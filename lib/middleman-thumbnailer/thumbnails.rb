require 'middleman-thumbnailer/asset'

module Middleman
  module Thumbnailer
    class Thumbnails
      attr_reader :assets
      attr_accessor :directory,
                    :extension,
                    :options

      def initialize(extension, directory)
        self.extension = extension
        self.options   = extension.options
        self.directory = directory
      end

      def filetypes_with_capitals
        options.filetypes.reduce([]) { |a, e| a.concat [e, e.upcase] }
      end

      def root
        extension.app.root
      end

      def glob
        "#{directory}/**/*.{#{filetypes_with_capitals.join(',')}}"
      end

      def assets
        @assets ||= Dir[glob].map do |file|
          Thumbnailer::Asset.new(self, file)
        end
      end

      def build
        assets.each(&:build)
      end
    end
  end
end
