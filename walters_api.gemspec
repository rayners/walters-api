# -*- encoding: utf-8 -*-
require File.expand_path('../lib/walters_api/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["David Raynes"]
  gem.email         = ["rayners@gmail.com"]
  gem.description   = %q{API for Walters Art Museum in Baltimore}
  gem.summary       = %q{API for Walters Art Museum in Baltimore}
  gem.homepage      = "https://github.com/rayners/walters-api"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "walters_api"
  gem.require_paths = ["lib"]
  gem.version       = WaltersApi::VERSION
  gem.add_dependency "nokogiri", "~> 1.5"
  gem.add_dependency "sinatra", ">= 1.3", "< 3.0"
  gem.add_dependency "json", "~> 1.7"
  gem.add_dependency "rack-cors"
end
