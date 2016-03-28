require 'fileutils'
require 'mime-types'

require 'middleman-thumbnailer/thumbnail-generator'
require 'middleman-thumbnailer/sitemap_extension'
require 'middleman-thumbnailer/helpers'
require 'middleman-thumbnailer/rack'

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

        options[:middleman_app] = app

        app.after_configuration do

          options[:build_dir] = build_dir

          #stash the source images dir in options for the Rack middleware
          options[:images_source_dir] = File.join(source_dir, images_dir)
          options[:source_dir] = source_dir

          dimensions = options[:dimensions]
          namespace = options[:namespace_directory]

          app.before_build do
            dir = File.join(source_dir, images_dir)


            files = DirGlob.glob(dir, namespace, options[:filetypes])

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

    class DirGlob
      def self.glob(root, namespaces, filetypes)
        filetypes_with_capitals = filetypes.reduce([]) { |memo, file| memo.concat [file, file.upcase] }
        glob_str = "#{root}/{#{namespaces.join(',')}}/**/*.{#{filetypes_with_capitals.join(',')}}"
        Dir[glob_str]
      end
    end
  end
end
