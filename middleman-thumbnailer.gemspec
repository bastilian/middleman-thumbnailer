# -*- encoding: utf-8 -*-
$:.unshift File.expand_path("./lib")
require "middleman-thumbnailer/version"

SUPPORTED_MIDDLEMAN = ENV['SUPPORTED_MIDDLEMAN'] || '~> 3.4.1'

Gem::Specification.new do |s|
  s.name        = "middleman-thumbnailer"
  s.version     = Middleman::Thumbnailer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = '~> 2.0'
  s.authors     = ["Nicholas Hemsley", "Sebastian Gräßl"]
  s.email       = ["nick.hems@gmail.com", "mail@bastilian.me"]
  s.homepage    = "https://github.com/bastilian/middleman-thumbnailer"
  s.licenses    = ['MIT']
  s.summary     = %q{Generate thumbnail versions of image files}
  s.description = s.summary

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_runtime_dependency("middleman", [SUPPORTED_MIDDLEMAN])
  s.add_runtime_dependency("rake", ['<= 11.0'])
  s.add_runtime_dependency("rmagick", ["~> 2.16.0"])
  s.add_runtime_dependency("mime-types", ["~> 2.1"])
end
