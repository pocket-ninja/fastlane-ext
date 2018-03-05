require_relative 'info_plist_controller'
require 'fastlane_core/ui/ui'

module FastlaneCraft
  module SharedValues
    APP_RELEASE_VERSION = 'APP_RELEASE_VERSION'.freeze
    APP_RELEASE_BUILD_NUMBER = 'APP_RELEASE_BUILD_NUMBER'.freeze
    APP_RELEASE_VERSION_TAG = 'APP_RELEASE_VERSION_TAG'.freeze
  end

  class AppReleaseManager
    include FastlaneCore
    include Gem

    def initialize(scheme, info_plist, extra_info_plists, branch, version = nil, target_suffix = nil)
      raise 'Invalid Branch' if branch.empty?
      raise 'Invalid Scheme' if scheme.empty?
      raise 'Invalid Version' if version && !version_valid?(version)

      @scheme = scheme
      @branch = branch
      @target_suffix = target_suffix
      @plist_controller = InfoPlistController.new(info_plist, extra_info_plists)
      @version = version.nil? ? @plist_controller.version : Version.new(version)
    end

    def release
      bump_version
      archive
      upload_to_tf
      update_env
      @plist_controller.bump_build_version_patch
      push_version_bump

      remove_last_git_tag_if_needed
      push_git_tag
    end

    def bump_version
      msg = 'Given version is less than the actual app version'
      UI.user_error! msg if @version < @plist_controller.version
      return unless @version > @plist_controller.version

      @plist_controller.set_version(@version)
      @plist_controller.set_build_version(Version.new(@version.to_s + '.0'))
      UI.success "Version was successfully bumped to #{version_dump}"
    end

    def upload_to_tf
      cmd = 'fastlane pilot upload --skip_submission --skip_waiting_for_build_processing'
      raise "TF uploading Failed! Command execution error: '#{cmd}'" unless system(cmd)
    end

    def update_env
      ENV[SharedValues::APP_RELEASE_VERSION] = @plist_controller.version.to_s
      ENV[SharedValues::APP_RELEASE_BUILD_NUMBER] = @plist_controller.build_version.to_s
      ENV[SharedValues::APP_RELEASE_VERSION_TAG] = version_dump
    end

    def push_version_bump
      cmd = "git add . && git commit -m 'Bump version to #{version_dump}'"
      raise "Git Commit Failed! Command execution error: '#{cmd}'" unless system(cmd)

      cmd = "git push origin HEAD:#{@branch}"
      raise "Git Push Failed! Command execution error: '#{cmd}'" unless system(cmd)
    end

    def archive
      cmd = "fastlane gym --configuration Release --scheme #{@scheme} --export_method app-store"
      raise "Archiving failed! Command execution error: '#{cmd}'" unless system(cmd)
    end

    def push_git_tag
      cmd = "git tag #{git_tag} && git push --tags"
      raise "Tag push failed! Command execution error: '#{cmd}'" unless system(cmd)
    end

    def remove_last_git_tag
      tag = last_git_tag
      cmd = "git tag -d #{tag} && git push origin :refs/tags/#{tag}"
      raise "Git tag deletion failed! Command execution error: '#{cmd}'" unless system(cmd)
    end

    def remove_last_git_tag_if_needed
      remove_last_git_tag if last_git_tag_version == @version
    end

    def git_tag
      return @version.to_s unless @target_suffix
      "#{@version}_#{@target_suffix}"
    end

    def last_git_tag_version
      tag = last_git_tag.match(/[0-9.]+/)[0]
      version_valid?(tag) ? Version.new(tag) : nil
    end

    def last_git_tag
      Actions.last_git_tag_name
    end

    def version_valid?(v)
      v.to_s.match?(/^\d\.\d\.\d{1,3}$/)
    end

    def version_dump
      "#{@plist_controller.version}/#{@plist_controller.build_version}"
    end
  end
end