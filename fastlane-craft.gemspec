require './lib/fastlane-craft/version'

Gem::Specification.new do |spec|
  spec.name         = "fastlane-craft"
  spec.version      = FastlaneCraft::VERSION
  spec.authors      = ["sroik", "elfenlaid"]
  spec.email        = "vasili.kazhanouski@gmail.com"
  spec.summary      = "fastlane craft summary"
  spec.description  = "fastlane craft"
  spec.license      = "MIT"
  spec.homepage     = "https://github.com/dt34m/fastlane-craft.git"
  spec.files        = Dir["{lib}/**/*.rb"]
end
