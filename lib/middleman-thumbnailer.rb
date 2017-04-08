require 'middleman-core'
require 'middleman-thumbnailer/version'
require 'middleman-thumbnailer/extension'

::Middleman::Extensions.register(:thumbnailer, Middleman::Thumbnailer::Extension)
