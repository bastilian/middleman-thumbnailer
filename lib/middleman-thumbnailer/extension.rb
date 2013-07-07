require 'rake'
module Middleman
  module Thumbnailer
    class << self
      def registered(app, options={})

        options[:something] ||= 'something'

        app.after_configuration do

          dir = File.join(build_dir, images_dir)
          prefix = build_dir + File::SEPARATOR

          after_build do |builder|
            files = FileList["#{dir}/**/*.svg*"]

            files.each do |file|
              puts file
            end
          end
        end
      end
      alias :included :registered
    end
  end
end