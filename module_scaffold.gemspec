# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'module_scaffold/version'

Gem::Specification.new do |spec|
  spec.name          = 'module_scaffold'
  spec.version       = ModuleScaffold::VERSION
  spec.authors       = ['Alexander Nosenko']
  spec.email         = ['sania.ace@gmail.com']

  spec.summary       = 'Opinionated module scaffold generator for Rails'
  spec.description   = 'For team using service-oriented approach for developing rails apis'
  spec.homepage      = 'https://github.com/AlexandrNosenko/module_scaffold'
  spec.license       = 'MIT'

  # spec.metadata["allowed_push_host"] = "https://github.com/"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/AlexandrNosenko/module_scaffold'
  spec.metadata['changelog_uri'] = 'https://github.com/AlexandrNosenko/module_scaffold'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_runtime_dependency 'pundit'
  spec.add_runtime_dependency 'rspec-rails'
  spec.add_runtime_dependency 'rswag-specs'

end
