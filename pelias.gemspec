# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pelias/version'

Gem::Specification.new do |spec|
  spec.name          = "pelias"
  spec.version       = Pelias::VERSION
  spec.authors       = ["Randy Meech"]
  spec.email         = ["randy@mapzen.com"]
  spec.description   = %q{Pelias is a set of tools to import OpenStreetMap, Quattroshapes, and Geonames data into Elasticsearch, and a simple server to handle queries.}
  spec.summary       = %q{Search engine and geocoder for OpenStreetMap}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "bundler", "~> 1.3"
  spec.add_dependency "debugger"
  spec.add_dependency "elasticsearch"
  spec.add_dependency "pg"
  spec.add_dependency "rake"
  spec.add_dependency "rgeo-geojson"
  spec.add_dependency "rgeo-shapefile"
  spec.add_dependency "rspec"
  spec.add_dependency "rubyzip"
  spec.add_dependency "sidekiq"
  spec.add_dependency "sinatra"
  spec.add_dependency "sinatra-cross_origin"
  spec.add_dependency "unicorn"

end
