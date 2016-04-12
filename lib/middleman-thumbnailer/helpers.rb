require 'ostruct'

module Middleman
  module Thumbnailer
    # Middleman Tempalte Helpers
    module Helpers
      def thumbnail_url(image, name)
        asset = Middleman::Thumbnailer::Asset.new(collection_options, image)
        asset.specs[name][:name]
      end

      def thumbnail(image, name, html_options = {})
        asset = Middleman::Thumbnailer::Asset.new(collection_options, image)

        if Middleman::Thumbnailer::Extension.options[:include_data_thumbnails]
          specs_for_data_attribute = asset.specs.map { |spec_name, spec| "#{spec_name}:#{spec[:name]}" }
          html_options.merge!('data-thumbnails' => specs_for_data_attribute.join('|'))
        end

        image_tag(thumbnail_url(image, name), html_options)
      end

      private

      def collection_options
        OpenStruct.new(options: Middleman::Thumbnailer::Extension.options)
      end
    end
  end
end
