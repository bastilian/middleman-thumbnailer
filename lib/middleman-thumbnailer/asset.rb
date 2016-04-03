require 'RMagick'

module Middleman
  module Thumbnailer
    class Asset
      attr_accessor :options,
                    :file,
                    :collection

      def initialize(collection, file)
        self.collection = collection
        self.options = collection.options
        self.file = file
      end

      def image
        @image ||= ::Magick::Image.read(file).first
      end

      def directory
        @directory ||= File.dirname(file)
      end

      def relative_directory
        directory.gsub(collection.extension.app.source_dir, '')[1..-1]
      end

      def build_directory
        collection.root + '/' + collection.extension.app.build_dir + '/' + relative_directory
      end

      def file_name
        File.basename(file, file_extension)
      end

      def file_extension
        File.extname(file)
      end

      def specs
        ret = { original: { name: File.basename(file) } }

        options.dimensions.each do |name, dimension|
          ret[name] = { name: "#{file_name}-#{name}-#{dimension}#{file_extension}", dimensions: dimension }
        end

        ret
      end

      def paths
        pa = {}

        specs.each do |_, spec|
          pa["#{relative_directory}/#{spec[:name]}"] = File.join(build_directory, spec[:name])
        end

        pa
      end

      def build
        FileUtils.mkdir_p build_directory unless Dir.exist? build_directory

        specs.each do |_, spec|
          next unless spec.key? :dimensions

          output_file = File.join(build_directory, spec[:name])

          next unless !File.exist?(output_file) || File.mtime(output_file) <= File.mtime(file)

          image.change_geometry(spec[:dimensions]) do |cols, rows, img|
            img = img.resize(cols, rows)
            img = img.sharpen(0.5, 0.5)
            img.write(output_file)
          end
        end
      end
    end
  end
end
