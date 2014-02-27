# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'longbow/version'

Gem::Specification.new do |spec|
  spec.name          = "longbow"
  spec.version       = Longbow::VERSION
  spec.authors       = ["Intermark Interactive"]
  spec.email         = ["interactive@intermarkgroup.com"]
  spec.description   = "Duplicates the main target of an xcodeproj/xcworkspace and renames it, its info.plist, and its image.xcassets as well. It then optionally reads from a .longbow.json file in your project directory that adds info.plist keys, urls to a 1024x1024 icon that it resizes to fit device type. It also handles "
  spec.summary       = "Better target creation for one iOS codebase."
  spec.homepage      = "https://github.com/intermark/longbow"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'bundler', '~> 1.3'
  spec.add_dependency 'fileutils'
  spec.add_dependency 'commander', '~> 4.1'
  spec.add_dependency 'dotenv', '~> 0.7'
  spec.add_dependency 'mini_magick', '~> 3.7.0'
  spec.add_dependency 'xcodeproj'

  spec.add_development_dependency "rake"

  spec.files         = Dir["./**/*"].reject { |file| file =~ /\.\/(bin|log|pkg|script|spec|test|vendor)/ }
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
