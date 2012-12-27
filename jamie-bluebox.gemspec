# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jamie/driver/bluebox_version'

Gem::Specification.new do |gem|
  gem.name          = "jamie-bluebox"
  gem.version       = Jamie::Driver::BLUEBOX_VERSION
  gem.authors       = ["Fletcher Nichol"]
  gem.email         = ["fnichol@nichol.ca"]
  gem.description   =
    %q{Jamie::Driver::Bluebox - A Blue Box block API driver for Jamie}
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/jamie-ci/jamie-bluebox"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = []
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'jamie'
  gem.add_dependency 'fog'

  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'maruku'
  gem.add_development_dependency 'cane'
  gem.add_development_dependency 'tailor'
end
