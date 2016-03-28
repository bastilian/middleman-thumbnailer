module Middleman
  module Thumbnailer
    # Add sitemap resource for every image in the sprockets load path
    class SitemapExtension
      def initialize(app)
        @app = app
      end

      def manipulate_resource_list(resources)

        images_dir_abs = File.join(@app.source_dir, @app.images_dir)

        images_dir = @app.images_dir

        options = Thumbnailer.options
        dimensions = options[:dimensions]
        namespace = options[:namespace_directory].join(',')

        files = DirGlob.glob(images_dir_abs, options[:namespace_directory], options[:filetypes])

        resource_list = files.map do |file|
          path = file.gsub(@app.source_dir + File::SEPARATOR, '')
          specs = ThumbnailGenerator.specs(path, dimensions)
          specs.map do |name, spec|
            resource = nil
            resource = Middleman::Sitemap::Resource.new(@app.sitemap, spec[:name], File.join(options[:build_dir], spec[:name])) unless name == :original
          end
        end.flatten.reject {|resource| resource.nil? }

        resources + resource_list
      end

    end
  end
end
