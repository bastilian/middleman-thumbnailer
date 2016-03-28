module Middleman
  module Thumbnailer
    # Add sitemap resource for every image in the sprockets load path
    class SitemapExtension
      attr_accessor :thumbnailer,
                    :app

      def initialize(thumbnailer)
        self.thumbnailer = thumbnailer
        self.app = thumbnailer.app
      end

      def manipulate_resource_list(resources)
        images_dir_abs = File.join(app.source_dir, app.images_dir)
        options = thumbnailer.options
        dimensions = options[:dimensions]

        files = DirGlob.glob(images_dir_abs, options.namespace_directory, options[:filetypes])

        resource_list = files.map do |file|
          path = file.gsub(app.source_dir + File::SEPARATOR, '')
          specs = ThumbnailGenerator.specs(path, dimensions)
          specs.map do |name, spec|
            unless name == :original
              Middleman::Sitemap::Resource.new(app.sitemap, spec[:name], File.join(app.build_dir, spec[:name]))
            end
          end
        end.flatten.reject {|resource| resource.nil? }

        resources + resource_list
      end

    end
  end
end
