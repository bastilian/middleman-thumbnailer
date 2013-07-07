require 'middleman-thumbnailer/thumbnail-generator'

module Middleman
  module Thumbnailer
    class << self
      def registered(app, options={})

        options[:something] ||= 'something'

        app.after_configuration do

          dimensions = options[:dimensions]

          dir = Pathname.new(File.join(build_dir, images_dir))
          prefix = build_dir + File::SEPARATOR

          after_build do |builder|
            files = FileList["#{dir}/**/*.{png,jpg,jpeg}*"]

            files.each do |file|

              specs = ThumbnailGenerator.specs(file, dimensions)
              ThumbnailGenerator.generate(dir, Pathname.new(build_dir.to_s), file, specs)
            end
          end
        end
      end
      alias :included :registered
    end
  end
end