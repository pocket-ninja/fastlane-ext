require_relative 'info_plist_controller'

module FastlaneCraft
  class TagReleaseManager
    def initialize(info_plist, extra_info_plists, target_suffix = nil)
      @target_suffix = target_suffix
      @plist_controller = InfoPlistController.new(info_plist, extra_info_plists)
    end

    def release
      puts 'releasing :)'
    end
  end
end

# lane :bump_version do |options|
#   if tag_version < app_version
#     UI.user_error! 'The version of the tag is less than the actual app version'
#   end
#
#   if tag_version > app_version
#     version = tag_version.to_s
#     build_version = Gem::Version.new(version.to_s + '.0')
#   elsif tag_version == app_version && options[:bump_patch]
#     version = app_version.to_s
#     build_version = bumped_version(app_build_version)
#   end
#
#   set_app_version(version)
#   set_app_build_version(build_version)
#   UI.success "Version was successfully bumped to #{version}/#{build_version}"
# end
#
# lane :push_version_bump do
#   commit_version_bump(
#     message: "Bump version to #{app_version}/#{app_build_version}",
#     force: true
#   )
#
#   push_to_git_remote(
#     local_branch: 'master',
#     remote_branch: 'master'
#   )
# end
#
# lane :release do
#   bump_version
#   certificates
#   archive_appstore
#   upload_to_testflight(skip_submission: true)
#   bump_version(bump_patch: true)
#   push_version_bump
#   broadcast_release
# end
#
# def tag_version
#   version_format = /[0-9.]+/
#   tag = last_git_tag.match(version_format)[0]
#   Gem::Version.new(tag)
# end
