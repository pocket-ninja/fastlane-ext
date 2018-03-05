require_relative '../test_helper'
require_relative '../../lib/fastlane-craft/app_release_manager'
require 'tempfile'

class AppReleaseManagerTest < Test::Unit::TestCase
  include Test::Unit::Assertions
  include FastlaneCraft
  include Gem

  def test_version
    assert_raise { release_manager('22.3.0') }
    assert_raise { release_manager('2.3') }
    assert_raise { release_manager('2') }
  end

  def test_get_tag
    manager = release_manager('1.3.0')
    assert_equal(manager.git_tag, '1.3.0')
    manager = release_manager('1.3.3', 'tst')
    assert_equal(manager.git_tag, '1.3.3_tst')
    manager = release_manager
    assert_equal(manager.git_tag, '1.2.3')
  end

  def test_env_variables
    with_info_plist_file do |file|
      manager = AppReleaseManager.new('s', file.path, [], 'master', '1.3.0')
      manager.bump_version
      manager.update_env
      assert_equal(ENV[SharedValues::APP_RELEASE_VERSION], '1.3.0')
      assert_equal(ENV[SharedValues::APP_RELEASE_BUILD_NUMBER], '1.3.0.0')
      assert_equal(ENV[SharedValues::APP_RELEASE_VERSION_TAG], '1.3.0/1.3.0.0')
    end
  end

  def test_version_bump
    with_info_plist_file do |file|
      manager = AppReleaseManager.new('s', file.path, [], 'master', '1.3.0')
      plist_controller = InfoPlistController.new(file.path)
      manager.bump_version
      assert_equal(plist_controller.version.to_s, '1.3.0')
      assert_equal(plist_controller.build_version.to_s, '1.3.0.0')
    end
  end

  private

  def release_manager(version = nil, suffix = nil)
    AppReleaseManager.new(
      'scheme',
      info_plist_path,
      [],
      'master',
      version,
      suffix
    )
  end
end
