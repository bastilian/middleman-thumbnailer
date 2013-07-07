# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "middleman-thumbnailer/version"

Gem::Specification.new do |s|
  s.name        = "middleman-thumbnailer"
  s.version     = Middleman::Thumbnailer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nicholas Hemsley"]
  s.email       = ["nick.hems@gmail.com"]
  s.homepage    = "https://github.com/nhemsley/middleman-thumbnailer"
  s.summary     = %q{Generate thumbnail versions of image files}
  s.description = s.summary

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_runtime_dependency("middleman", [">= 3.0.0"])
  s.add_runtime_dependency("rake", [">= 0"])

  s.add_development_dependency 'pry'
  s.add_development_dependency 'pry-nav'
  s.add_development_dependency 'rspec'
end
