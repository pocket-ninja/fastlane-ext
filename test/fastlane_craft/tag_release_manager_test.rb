require_relative '../test_helper'
require_relative '../../lib/fastlane_craft/tag_release_manager'
require 'tempfile'

class InfoPlistControllerTest < Test::Unit::TestCase
  include Test::Unit::Assertions
  include FastlaneCraft
  include Gem

  def test_tag_version
    manager = release_manager('v2.3.0_tst', 'tst')
    assert_equal(manager.tag_version.to_s, '2.3.0')
    assert_true(manager.tag_valid?)
  end

  def test_invalid_tag
    manager = release_manager('v2.3.0_invalid')
    assert_false(manager.tag_valid?)
  end

  def test_version_bump
    with_info_plist_file do |file|
      manager = TagReleaseManager.new('s', file.path, [], 'master', '1.3.0')
      plist_controller = InfoPlistController.new(file.path)
      manager.bump_version
      assert_equal(plist_controller.version.to_s, '1.3.0')
      assert_equal(plist_controller.build_version.to_s, '1.3.0.0')
    end
  end

  private

  def release_manager(tag, suffix = 'tst')
    TagReleaseManager.new(
      'scheme',
      info_plist_path,
      [],
      'master',
      tag,
      suffix
    )
  end
end
