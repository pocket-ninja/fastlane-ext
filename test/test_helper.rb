require 'fastlane'
require 'test/unit'
require 'fileutils'
require_relative '../lib/fastlane-craft'

class Test::Unit::TestCase
  include FastlaneCraft

  def with_project
    Dir.mktmpdir do |dir|
      path = "#{dir}/#{mock_xcodeproj}"
      FileUtils.cp_r(project_path, path)
      yield path if block_given?
    end
  end

  def project_path
    File.expand_path("resources/#{mock_xcodeproj}", __dir__)
  end
  
  def project_schemes
    ['Match3']
  end

  def mock_xcodeproj
    'mock.xcodeproj'
  end
end
