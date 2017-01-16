require "middleman-core"

Middleman::Extensions.register :thumbnailer do
  require "middleman-thumbnailer/extension"
  ::Middleman::Thumbnailer::Extension
end
