require './lib/legend/version'

Gem::Specification.new do |spec|
  spec.name = 'legend'
  spec.version = Legend::VERSION
  spec.authors = ['Tyler Hunt']
  spec.email = ['tyler@tylerhunt.com']
  spec.summary = 'Interface to the Epic API.'

  spec.files = `git ls-files`.split($/)
  spec.executables = spec.files.grep(%r{^bin/}) { |file| File.basename(file) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 0.9'
  spec.add_dependency 'faraday-conductivity', '~> 0.3'
  spec.add_dependency 'hashie', '~> 2.0'
  spec.add_dependency 'multi_xml', '~> 0.5'
  spec.add_dependency 'ox', '~> 2.0'
  spec.add_dependency 'virtus', '~> 1.0'

  # required by simulators, but marked as development in case they're unused
  spec.add_development_dependency 'factory_girl', '~> 4.0'
  spec.add_development_dependency 'faker', '~> 1.2.0'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
end
