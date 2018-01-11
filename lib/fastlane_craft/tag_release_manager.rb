module FastlaneCraft
  class TagReleaseManager
    def initialize(info_plist_path, target_suffix = nil)
      raise 'Invalid Info Plist Path' if info_plist_path.empty?
      @info_plist_path = info_plist_path
      @target_suffix = target_suffix
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
# def bumped_version(v)
#   value = v.to_s
#   value[-1] = (value[-1].to_i + 1).to_s
#   Gem::Version.new(value)
# end
#
# def tag_version
#   version_format = /[0-9.]+/
#   tag = last_git_tag.match(version_format)[0]
#   Gem::Version.new(tag)
# end
#
# def set_app_version(v)
#   value = set_info_plist_value(
#     path: info_plist_path,
#     key: info_plist_version_key,
#     value: v.to_s
#   )
# end
#
# def set_app_build_version(v)
#   value = set_info_plist_value(
#     path: info_plist_path,
#     key: info_plist_build_version_key,
#     value: v.to_s
#   )
# end
#
# def app_version
#   value = get_info_plist_value(path: info_plist_path, key: info_plist_version_key)
#   Gem::Version.new(value)
# end
#
# def app_build_version
#   value = get_info_plist_value(path: info_plist_path, key: info_plist_build_version_key)
#   Gem::Version.new(value)
# end
#
# def info_plist_version_key
#   'CFBundleShortVersionString'
# end
#
# def info_plist_build_version_key
#   'CFBundleVersion'
# end
#
# def info_plist_path
#   File.join(Dir.pwd, '../PixelArt/Supporting Files/Info.plist')
# end
