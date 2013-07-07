require 'pry'
module Middleman
  #actually creates the thumbnail names
  class ThumbnailGenerator
    class << self

      def generate(filename, dimensions)
        ret = {original: filename}
        file_parts = filename.split('.')
        basename = file_parts[0..-2].join('.')
        ext = file_parts.last

        dimensions.each do |name, dimension|
          ret[name] = "#{basename}-#{name}-#{dimension}.#{ext}"
        end

        ret
      end
    end
  end
end
