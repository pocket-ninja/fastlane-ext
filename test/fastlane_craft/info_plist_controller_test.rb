require_relative '../test_helper'
require_relative '../../lib/fastlane_craft/info_plist_controller'
require 'tempfile'

class InfoPlistControllerTest < Test::Unit::TestCase
  include Test::Unit::Assertions
  include FastlaneCraft
  include Gem

  def test_build_version_bump
    with_info_plist_file do |file|
      controller = InfoPlistController.new(file.path)
      controller.bump_build_version_patch
      assert_equal(controller.build_version.to_s, '1.2.3.1')
    end
  end

  def test_set_version
    with_info_plist_file do |file|
      controller = InfoPlistController.new(file.path)
      controller.set_version(Version.new('1.0.0'))
      controller.set_build_version(Version.new('1.0.0.1'))
      assert_equal(controller.version.to_s, '1.0.0')
      assert_equal(controller.build_version.to_s, '1.0.0.1')
    end
  end

  def test_version_read
    controller = InfoPlistController.new(info_plist_path)
    assert_equal(controller.version.to_s, '1.2.3')
    assert_equal(controller.build_version.to_s, '1.2.3.0')
  end
end
