require 'RMagick'

module Middleman
  #actually creates the thumbnail names
  class ThumbnailGenerator
    class << self

      def specs(origin, dimensions)
        ret = {original: {name: origin}}
        file_parts = origin.split('.')
        basename = file_parts[0..-2].join('.')
        ext = file_parts.last

        dimensions.each do |name, dimension|
          ret[name] = {name: "#{basename}-#{name}-#{dimension}.#{ext}", dimensions: dimension}
        end

        ret
      end

      def generate(source_dir, output_dir, origin, specs)
        image = nil
        origin_absolute = Path.join source_dir, origin
        specs.each do |name, spec|
          if spec.has_key? :dimensions then
            origin_mtime = File.mtime origin_absolute
            if origin_mtime != File.mtime(spec[:name])
              image ||= ::Magick::Image.read(origin_absolute).first
              thumbnail_absolute = File.join output_dir, spec[:name]
              image.change_geometry(spec[:dimensions]) do |cols, rows, img|
                img = img.resize(cols, rows)
                img = img.sharpen(0.5, 0.5)
                img.write thumbnail_absolute
              end
              File.utime(origin_mtime, origin_mtime, thumbnail_absolute)
            end
          end
        end
      end

      def original_map_for_files(files, specs)
        map = files.inject({}) do |memo, file|
          generated_specs = self.specs(file, specs)
          generated_specs.each do |name, spec|
            memo[spec[:name]] = {:original => generated_specs[:original][:name], :spec => spec}
          end
          memo
        end
      end
    end
  end
end
