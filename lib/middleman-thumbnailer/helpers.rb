module Middleman
  module Thumbnailer
    # Middleman Tempalte Helpers
    module Helpers
      def thumbnail_specs(image, name)
        dimensions = Thumbnailer.options[:dimensions]
        ThumbnailGenerator.specs(image, dimensions)
      end

      def thumbnail_url(image, name, options = {})
        include_images_dir = options.delete :include_images_dir

        url = thumbnail_specs(image, name)[name][:name]
        url = File.join(images_dir, url) if include_images_dir

        url
      end

      def thumbnail(image, name, html_options = {})
        specs_for_data_attribute = thumbnail_specs(image, name).map {|name, spec| "#{name}:#{spec[:name]}"}

        html_options.merge!({'data-thumbnails' => specs_for_data_attribute.join('|')}) if Thumbnailer.options[:include_data_thumbnails]

        image_tag(thumbnail_url(image, name), html_options)
      end
    end
  end
end
