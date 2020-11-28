# frozen_string_literal: true

require_relative 'lib/spellchecker/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby-spellchecker'
  spec.version       = Spellchecker::VERSION
  spec.authors       = ['Pete Matsyburka']
  spec.email         = ['pete.matsy@gmail.com']
  spec.licenses      = ['MIT']

  spec.summary       = 'Fast Ruby spellchecker.'
  spec.description   = 'Ruby spelling and grammar checker that can be used for autocorrection.'
  spec.homepage      = 'https://github.com/omohokcoj/ruby-spellchecker'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.require_paths = ['lib']

  spec.add_development_dependency 'rspec', '~> 3.10.0'
  spec.add_development_dependency 'rubocop', '~> 1.3.1'
  spec.add_development_dependency 'simplecov', '~> 0.19.1'
  spec.add_development_dependency 'yard', '~> 0.9.25'
end
