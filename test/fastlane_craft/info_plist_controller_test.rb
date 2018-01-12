require_relative '../test_helper'
require_relative '../../lib/fastlane_craft/info_plist_controller'
require 'webmock/test_unit'
require 'tempfile'

class InfoPlistControllerTest < Test::Unit::TestCase
  include Test::Unit::Assertions
  include FastlaneCraft

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
      controller.set_version('1.0.0')
      controller.set_build_version('1.0.0.1')
      assert_equal(controller.version.to_s, '1.0.0')
      assert_equal(controller.build_version.to_s, '1.0.0.1')
    end
  end

  def test_version_read
    controller = InfoPlistController.new(info_plist_path)
    assert_equal(controller.version.to_s, '1.2.3')
    assert_equal(controller.build_version.to_s, '1.2.3.0')
  end

  private

  def with_info_plist_file
    file = Tempfile.new(%w[info .plist], File.dirname(__FILE__))
    begin
      file.write(info_plist)
      file.close
      yield file if block_given?
    ensure
      file.unlink
    end
  end

  def info_plist
    File.read(info_plist_path)
  end

  def info_plist_path
    File.expand_path('../../resources/mock_info.plist', __FILE__)
  end
end
