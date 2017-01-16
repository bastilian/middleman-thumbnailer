require 'fileutils'
require 'mime-types'

require 'middleman-core'

require 'middleman-thumbnailer/dir_glob'
require 'middleman-thumbnailer/generator'
require 'middleman-thumbnailer/rack'

module Middleman
  module Thumbnailer
    class Extension < ::Middleman::Extension

      option :filetypes, [:jpg, :jpeg, :png], 'Filetypes of images to generate'
      option :include_data_thumbnails, false, 'Include data thumbnails'
      option :namespace_directory, ['**'], 'Namespace directory'
      option :include_images_dir, false, 'Include the images dir'
      option :dimensions, {}, 'Dimensions to use'

      def initialize(app, options_hash={}, &block)
        super

        # app.helpers Helpers
        #
        # options[:middleman_app] = app
        #
        # app.after_configuration do
        #
        #   options[:build_dir] = build_dir
        #
        #   #stash the source images dir in options for the Rack middleware
        #   options[:images_source_dir] = File.join(source_dir, images_dir)
        #   options[:source_dir] = source_dir
        #
        #   dimensions = options[:dimensions]
        #   namespace = options[:namespace_directory]
        #
        #   app.before_build do
        #     dir = File.join(source_dir, app.config[:images_dir])
        #
        #
        #     files = DirGlob.glob(dir, namespace, options[:filetypes])
        #
        #     files.each do |file|
        #       path = file.gsub(source_dir, '')
        #       specs = ThumbnailGenerator.specs(path, dimensions)
        #       ThumbnailGenerator.generate(source_dir, File.join(root, build_dir), path, specs)
        #     end
        #   end
        #
        #   sitemap.register_resource_list_manipulator(:thumbnailer, SitemapExtension.new(self), true)
        #
        #   app.use Rack, options
        # end
        app.before_build do |builder|
          opts = extensions[:thumbnailer].options
          dir = File.join(source_dir, app.config[:images_dir])
          files = ::Middleman::Thumbnailer::DirGlob.glob(dir, opts[:namespace_directory], opts[:filetypes])

          files.each do |file|
            path = file.gsub(app.source_dir.to_s, '')
            specs = ::Middleman::Thumbnailer::Generator.specs(path, opts[:dimensions])
            ::Middleman::Thumbnailer::Generator.generate(app.source_dir, File.join(app.root, app.config[:build_dir]), path, specs)
            specs.each do |key, spec|
              next if key == :original
              builder.thor.say_status :generate, spec[:name]
            end
          end
        end
      end

      def after_configuration
        # opts = {}
        # opts[:middleman_app] = app
        # opts[:build_dir] = app.config[:build_dir]
        # opts[:images_source_dir] = File.join(app.source_dir, app.config[:images_dir])
        # options[:source_dir] = app.source_dir

      end

      def ready
        app.use ::Middleman::Thumbnailer::Rack, options, app
      end

      def manipulate_resource_list(resources)
        images_dir = app.config[:images_dir]
        images_dir_abs = File.join(app.source_dir, images_dir)

        options = app.extensions[:thumbnailer].options
        dimensions = options[:dimensions]
        namespace = options[:namespace_directory].join(',')
        files = ::Middleman::Thumbnailer::DirGlob.glob(images_dir_abs, options[:namespace_directory], options[:filetypes])

        resource_list = files.map do |file|
          path = file.gsub(app.source_dir.to_s + File::SEPARATOR, '')
          specs = ::Middleman::Thumbnailer::Generator.specs(path, dimensions)

          specs.map do |name, spec|
            resource = nil
            begin
              resource = Middleman::Sitemap::Resource.new(app.sitemap,
                spec[:name],
                File.join(app.root, app.config[:build_dir], spec[:name])
              ) unless name == :original
            rescue
              binding.pry
            end
          end
        end.flatten.reject {|resource| resource.nil? }

        resources + resource_list
      end
      #
      # def before_build(builder)
      #
      # end
      #
      # def manipulate_resource_list(resources)
      #
      #   images_dir_abs = File.join(app.source_dir, app.images_dir)
      #
      #   images_dir = app.images_dir
      #
      #   options = Thumbnailer.options
      #   dimensions = options[:dimensions]
      #   namespace = options[:namespace_directory].join(',')
      #
      #   files = DirGlob.glob(images_dir_abs, options[:namespace_directory], options[:filetypes])
      #
      #   resource_list = files.map do |file|
      #     path = file.gsub(app.source_dir + File::SEPARATOR, '')
      #     specs = ThumbnailGenerator.specs(path, dimensions)
      #
      #     specs.map do |name, spec|
      #       resource = nil
      #       resource = Middleman::Sitemap::Resource.new(app.sitemap, spec[:name], File.join(options[:build_dir], spec[:name])) unless name == :original
      #     end
      #   end.flatten.reject {|resource| resource.nil? }
      #
      #   resources + resource_list
      # end
      #
      #

      helpers do
        def thumbnail_specs(image, name)
          opts = extensions[:thumbnailer].options
          dimensions = opts[:dimensions]
          ::Middleman::Thumbnailer::Generator.specs(image, dimensions)
        end

        def thumbnail_url(image, name, options = {})
          opts = extensions[:thumbnailer].options
          url = thumbnail_specs(image, name)[name][:name]
          url = File.join(app.config[:images_dir], url) if opts[:include_images_dir]

          url
        end

        def thumbnail(image, name, html_options = {})
          opts = extensions[:thumbnailer].options
          specs_for_data_attribute = thumbnail_specs(image, name).map {|name, spec| "#{name}:#{spec[:name]}"}

          html_options.merge!({'data-thumbnails' => specs_for_data_attribute.join('|')}) if opts[:include_data_thumbnails]

          image_tag(thumbnail_url(image, name), html_options)
        end
      end
    end

  #
  #
  #   class SitemapExtension
  #     def initialize(app)
  #       @app = app
  #     end
  #
  #     # Add sitemap resource for every image in the sprockets load path
  #
  #   end
  end
end
