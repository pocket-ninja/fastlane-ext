Gem::Specification.new do |spec|
  spec.name         = 'fastlane-craft'
  spec.version      = '1.1.0'
  spec.authors      = ['sroik', 'elfenlaid']
  spec.email        = 'vasili.kazhanouski@gmail.com'
  spec.summary      = 'fastlane craft summary'
  spec.description  = 'fastlane craft'
  spec.license      = 'MIT'
  spec.homepage     = 'https://github.com/app-craft/fastlane-craft.git'
  spec.files        = Dir['{lib}/**/*.rb']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'webmock'
end
