require 'middleman-thumbnailer/asset'

module Middleman
  module Thumbnailer
    class Thumbnails
      attr_reader :assets
      attr_accessor :directories,
                    :extension,
                    :options

      def initialize(extension, directories)
        self.extension = extension
        self.options   = extension.options
        self.directories = [*directories]
      end

      def filetypes_with_capitals
        options.filetypes.reduce([]) { |a, e| a.concat [e, e.upcase] }
      end

      def root
        extension.app.root
      end

      def glob(directory)
        "#{directory}/**/*.{#{filetypes_with_capitals.join(',')}}"
      end

      def assets
        @assets ||= directories.flat_map { |dir| assets_for(dir) }
      end

      def build
        assets.each(&:build)
      end

      private

      def assets_for(directory)
        Dir[glob(directory)].map do |file|
          Thumbnailer::Asset.new(self, file)
        end
      end
    end
  end
end
