# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/fastlane-ext/project_controller'

class InfoPlistControllerTest < Test::Unit::TestCase
  include Test::Unit::Assertions
  include FastlaneExt
  include Gem

  def test_build_version_bump
    with_project do |project|
      controller = ProjectController.new(project, project_schemes)
      controller.bump_build_version_patch
      assert_equal(controller.build_version.to_s, '1.2.3.5')
    end
  end

  def test_set_version
    with_project do |project|
      controller = ProjectController.new(project, project_schemes)
      controller.set_version(Version.new('1.0.0'))
      controller.set_build_version(Version.new('1.0.0.1'))
      assert_equal(controller.version.to_s, '1.0.0')
      assert_equal(controller.build_version.to_s, '1.0.0.1')
    end
  end

  def test_version_read
    controller = ProjectController.new(project_path, project_schemes)
    assert_equal(controller.version.to_s, '1.2.3')
    assert_equal(controller.build_version.to_s, '1.2.3.4')
  end
end
