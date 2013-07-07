require "middleman-core"

require "middleman-thumbnailer/version"

::Middleman::Extensions.register(:thumbnailer) do
  require "middleman-thumbnailer/extension"
  ::Middleman::Thumbnailer
end