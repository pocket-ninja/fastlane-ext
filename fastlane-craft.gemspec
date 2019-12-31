require File.expand_path('lib/fastlane-craft/version', __dir__)

Gem::Specification.new do |spec|
  spec.name         = 'fastlane-craft'
  spec.version      = FastlaneCraft::VERSION
  spec.authors      = %w[sroik elfenlaid]
  spec.email        = 'vasili.kazhanouski@gmail.com'
  spec.summary      = 'fastlane craft summary'
  spec.description  = 'fastlane craft'
  spec.license      = 'MIT'
  spec.homepage     = 'https://github.com/app-craft/fastlane-craft.git'
  spec.files        = Dir['{lib}/**/*.rb']

  spec.add_dependency 'aws-sdk-s3', '> 0'
  spec.add_dependency 'fastlane', '> 0'
  spec.add_dependency 'xcodeproj', '> 0'
  spec.add_development_dependency 'bundler', '> 0'
  spec.add_development_dependency 'gem-release', '> 0'
  spec.add_development_dependency 'rake', '> 0'
  spec.add_development_dependency 'rubocop', '> 0.52'
  spec.add_development_dependency 'test-unit', '> 0'
  spec.add_development_dependency 'webmock', '> 0'
end
