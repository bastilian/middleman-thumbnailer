require 'rmagick'

require 'pry'
module Middleman
  #actually creates the thumbnail names
  class ThumbnailGenerator
    class << self

      def specs(origin, dimensions)
        ret = {original: origin}
        file_parts = origin.split('.')
        basename = file_parts[0..-2].join('.')
        ext = file_parts.last

        dimensions.each do |name, dimension|
          ret[name] = {name: "#{basename}-#{name}-#{dimension}.#{ext}", dimensions: dimension}
        end

        ret
      end

      def generate(dir, output_dir, origin, specs)
        specs.each do |name, spec|
          image = RMagick::new dir.join(origin).to_s
          image.change_geometry(spec[:dimensions]) do |cols, rows, img|
            image.resize(cols, rows)
            image.write output_dir.join(spec[:name])
          end
        end
      end
    end
  end
end
