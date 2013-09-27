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

      def generate(dir, output_dir, origin, specs)
        image = nil
        specs.each do |name, spec|
          if spec.has_key? :dimensions then
            origin_mtime = File.mtime(origin)
            if origin_mtime != File.mtime(spec[:name])
              image ||= ::Magick::Image.read(origin).first
              image.change_geometry(spec[:dimensions]) do |cols, rows, img|
                image.resize!(cols, rows)
                image.write spec[:name]
              end
              File.utime(origin_mtime, origin_mtime, spec[:name])
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
