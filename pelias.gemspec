# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pelias/version'

Gem::Specification.new do |spec|

  spec.name          = 'pelias'
  spec.version       = Pelias::VERSION
  spec.authors       = ['Randy Meech']
  spec.email         = ['randy@mapzen.com']
  spec.description   = %q{A set of tools to import and search OpenStreetMap, Quattroshapes, and Geonames data}
  spec.summary       = %q{Search engine and geocoder for OpenStreetMap}
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

end
