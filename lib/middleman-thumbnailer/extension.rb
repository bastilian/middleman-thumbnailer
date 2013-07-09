require 'middleman-thumbnailer/thumbnail-generator'

module Middleman
  module Thumbnailer
    class << self

      attr_accessor :options

      def registered(app, options={})

        options[:filetypes] ||= [:jpg, :jpeg, :png]
        options[:include_data_thumbnails] = false unless options.has_key? :include_data_thumbnails
        options[:namespace_directory] = ["**"] unless options.has_key? :namespace_directory

        Thumbnailer.options = options

        app.helpers Helpers

        app.after_configuration do

          #stash the source images dir in options for the Rack middleware
          options[:images_source_dir] = File.join(source_dir, images_dir)
          options[:source_dir] = source_dir

          dimensions = options[:dimensions]
          namespace = options[:namespace_directory].join(',')

          dir = Pathname.new(File.join(source_dir, images_dir))

          after_build do |builder|
            glob = "#{dir}/#{namespace}/*.{#{options[:filetypes].join(',')}}"
            files = Dir[glob]

            files.each do |file|
              path = file.gsub(source_dir, '')
              specs = ThumbnailGenerator.specs(path, dimensions)
              ThumbnailGenerator.generate(source_dir, File.join(root, build_dir), path, specs)
            end
          end

          sitemap.register_resource_list_manipulator(:thumbnailer, SitemapExtension.new(self), true)

          app.use Rack, options
        end
      end
      alias :included :registered
    end

    module Helpers
      def thumbnail(image, name, html_options = {})
        options = Thumbnailer.options
        dimensions = options[:dimensions]
        specs = ThumbnailGenerator.specs(image, dimensions)

        specs_for_data_attribute = specs.map {|name, spec| "#{name}:#{spec[:name]}"}

        html_options.merge!({'data-thumbnails' => specs_for_data_attribute.join('|')}) if options[:include_data_thumbnails]

        image_tag(specs[name][:name], html_options)
      end
    end

    class SitemapExtension
      def initialize(app)
        @app = app
      end

      # Add sitemap resource for every image in the sprockets load path
      def manipulate_resource_list(resources)

        images_dir_abs = File.join(@app.source_dir, @app.images_dir)

        images_dir = @app.images_dir

        options = Thumbnailer.options
        dimensions = options[:dimensions]
        namespace = options[:namespace_directory].join(',')

        files = Dir["#{images_dir_abs}/#{namespace}/*.{#{options[:filetypes].join(',')}}"]

        resource_list = files.map do |file|
          path = file.gsub(@app.source_dir, '')
          specs = ThumbnailGenerator.specs(path, dimensions)
          specs.map do |name, spec|
            resource = nil
            # puts "#{path}: #{spec[:name]}: #{file}"
            resource = Middleman::Sitemap::Resource.new(@app.sitemap, spec[:name], file) unless name == :original
          end
        end.flatten.reject {|resource| resource.nil? }

        resources + resource_list
      end
    end


    # Rack middleware to convert images on the fly
    class Rack

      # Init
      # @param [Class] app
      # @param [Hash] options
      def initialize(app, options={})
        @app = app
        @options = options

        files = Dir["#{options[:images_source_dir]}/**/*.{#{options[:filetypes].join(',')}}"]

        @original_map = ThumbnailGenerator.original_map_for_files(files, options[:dimensions])

      end

      # Rack interface
      # @param [Rack::Environmemt] env
      # @return [Array]
      def call(env)
        status, headers, response = @app.call(env)

        path = env["PATH_INFO"]

        path_on_disk = File.join(@options[:source_dir], path)

        #TODO: caching
        if original_specs = @original_map[path_on_disk]
          original_file = original_specs[:original]
          spec = original_specs[:spec]
          if spec.has_key? :dimensions
            image = ::Magick::Image.read(original_file).first
            blob = nil
            image.change_geometry(spec[:dimensions]) do |cols, rows, img|
              image.resize!(cols, rows)
              blob = image.to_blob
            end

            unless blob.nil?
              status = 200
              headers["Content-Length"] = ::Rack::Utils.bytesize(blob).to_s
              headers["Content-Type"] = image.mime_type
              response = [blob]
            end
          end
        end

        [status, headers, response]
      end
    end
  end
end