# -*- encoding: utf-8 -*-
require File.expand_path('../lib/walters_api/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["David Raynes"]
  gem.email         = ["rayners@gmail.com"]
  gem.description   = %q{API for Walters Art Museum in Baltimore}
  gem.summary       = %q{API for Walters Art Museum in Baltimore}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "walters_api"
  gem.require_paths = ["lib"]
  gem.version       = WaltersApi::VERSION
  gem.add_runtime_dependency "nokogiri"
end
