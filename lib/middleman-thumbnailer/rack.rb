require 'middleman-thumbnailer/thumbnail-generator'
require 'rack/utils'
require 'mime-types'

module Middleman
  module Thumbnailer
    class DirGlob
      def self.glob(root, namespaces, filetypes)
        filetypes_with_capitals = filetypes.reduce([]) { |memo, file| memo.concat [file, file.upcase] }
        glob_str = "#{root}/{#{namespaces.join(',')}}/**/*.{#{filetypes_with_capitals.join(',')}}"
        Dir[glob_str]
      end
    end

    # Rack middleware to convert images on the fly
    class Rack

      def initialize(app, options = {})
        @app = app
        @options = options
        files = DirGlob.glob(options[:images_source_dir], options[:namespace_directory], options[:filetypes])
        @original_map = ThumbnailGenerator.original_map_for_files(files, options[:dimensions])
      end

      # Rack interface
      # @param [Rack::Environmemt] env
      # @return [Array]
      def call(env)
        status, headers, response = @app.call(env)
        path = env['PATH_INFO']
        absolute_path = File.join(@options[:source_dir], path)
        root_dir = @options.root
        tmp_dir = File.join(root_dir, 'tmp', 'middleman-thumbnail-cache')

        if original_specs = @original_map[absolute_path]
          thumbnail_path = Pathname.new original_specs[:spec][:name]
          #the name for the generate spec filename is relative to the source dir, remove this
          thumbnail_path = thumbnail_path.relative_path_from Pathname.new(@options[:source_dir])

          cache_file = File.join tmp_dir, thumbnail_path.to_s
          cache_dir = File.dirname cache_file
          FileUtils.mkdir_p(cache_dir) unless Dir.exist?(cache_dir)

          file_info = nil
          file_data = nil

          original_file = original_specs[:original]
          original_mtime = File.mtime original_file
          if File.exist?(cache_file) && (original_mtime == File.mtime(cache_file))
            file_data = IO.read(cache_file)
            file_info = {length: ::Rack::Utils.bytesize(file_data).to_s, mime_type: ::MIME::Types.type_for(cache_file).first.to_s}
          else
            image = ThumbnailGenerator.image_for_spec(original_file, original_specs[:spec])
            file_data = image.to_blob

            file_info = {length: ::Rack::Utils.bytesize(file_data).to_s, mime_type: image.mime_type}

            File.open(cache_file, 'wb') do |file|
              file.write file_data
            end

            File.utime(original_mtime, original_mtime, cache_file)

            image.destroy!
          end

          status = 200
          headers["Content-Length"] = file_info[:length]
          headers["Content-Type"] = file_info[:mime_type]
          response = [file_data]
        end
        [status, headers, response]
      end
    end
  end
end
