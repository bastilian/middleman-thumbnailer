require 'fileutils'
require 'mime-types'

require 'middleman-thumbnailer/thumbnail-generator'
require 'middleman-thumbnailer/sitemap_extension'
require 'middleman-thumbnailer/helpers'
require 'middleman-thumbnailer/rack'

module Middleman
  module Thumbnailer
    class Extension < Middleman::Extension
      helpers Helpers

      option :dimensions
      option :namespace_directory, ['**']
      option :filetypes, [:jpg, :jpeg, :png]
      option :include_data_thumbnails, false
      option :images_source_dir
      option :source_dir
      option :root

      def after_configuration
        # stash the source images dir in options for the Rack middleware
        options[:images_source_dir] = File.join(app.source_dir, app.images_dir)
        options[:source_dir] = app.source_dir
        options[:root] = app.root

        app.sitemap.register_resource_list_manipulator(:thumbnailer, SitemapExtension.new(self), true)

        app.use Rack, options
      end

      def directory
        @dir ||= File.join(app.source_dir, app.images_dir)
      end

      def files
        @files ||= DirGlob.glob(directory, options[:namespace_directory], options[:filetypes])
      end

      def before_build
        files.each do |file|
          path = file.gsub(app.source_dir, '')
          specs = ThumbnailGenerator.specs(path, options[:dimensions])
          ThumbnailGenerator.generate(app.source_dir, File.join(app.root, app.build_dir), path, specs)
        end
      end
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
