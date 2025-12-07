# frozen_string_literal: true

require File.expand_path('lib/fastlane-ext/version', __dir__)

Gem::Specification.new do |spec|
  spec.name         = 'fastlane-ext'
  spec.version      = FastlaneExt::VERSION
  spec.authors      = %w[sroik]
  spec.email        = 'vasili.kazhanouski@gmail.com'
  spec.summary      = 'fastlane ext summary'
  spec.description  = 'fastlane ext'
  spec.license      = 'MIT'
  spec.homepage     = 'https://github.com/pocket-ninja/fastlane-ext'
  spec.files        = Dir['{lib}/**/*.rb']

  spec.add_dependency 'aws-sdk-s3', '> 0'
  spec.add_dependency 'xcodeproj', '> 0'
  spec.add_dependency 'openssl', '> 0'
  spec.add_development_dependency 'bundler', '> 0'
  spec.add_development_dependency 'gem-release', '> 0'
  spec.add_development_dependency 'rake', '> 0'
  spec.add_development_dependency 'rubocop', '> 0.52'
  spec.add_development_dependency 'test-unit', '> 0'
  spec.add_development_dependency 'webmock', '> 0'
end
