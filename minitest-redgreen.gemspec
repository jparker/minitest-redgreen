# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'minitest/redgreen/version'

Gem::Specification.new do |gem|
  gem.name          = "minitest-redgreen"
  gem.version       = MiniTest::Redgreen::VERSION
  gem.authors       = ["John Parker"]
  gem.email         = ["jparker@urgetopunt.com"]
  gem.description   = %q{Colorize minitest test output.}
  gem.summary       = %q{Colorize minitest output: failing red, pending yellow, passing green.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'minitest', '~> 5.0'
  gem.add_development_dependency 'rake'
end
