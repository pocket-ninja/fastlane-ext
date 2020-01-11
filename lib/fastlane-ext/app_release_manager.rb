# frozen_string_literal: true

require_relative 'project_controller'
require 'fastlane_core/ui/ui'

module FastlaneExt
  module SharedValues
    APP_RELEASE_VERSION = 'APP_RELEASE_VERSION'
    APP_RELEASE_BUILD_NUMBER = 'APP_RELEASE_BUILD_NUMBER'
    APP_RELEASE_VERSION_TAG = 'APP_RELEASE_VERSION_TAG'
  end

  class AppReleaseManager
    include FastlaneCore
    include Gem

    def initialize(schemes, project, branch, version = nil, target_suffix = nil)
      raise 'Invalid Version' if version && !version_valid?(version)

      @scheme = schemes.first
      @branch = branch
      @target_suffix = target_suffix
      @project_controller = ProjectController.new(project, schemes)
      @version = version.nil? ? @project_controller.version : Version.new(version)
    end

    def release
      bump_version
      archive
      upload_to_tf
      update_env
      @project_controller.bump_build_version_patch
      push_version_bump

      remove_existing_git_tag
      push_git_tag
    end

    def bump_version
      msg = 'Given version is less than the actual app version'
      UI.user_error! msg if @version < @project_controller.version
      return unless @version > @project_controller.version

      @project_controller.set_version(@version)
      @project_controller.set_build_version(Version.new(@version.to_s + '.0'))
      UI.success "Version was successfully bumped to #{version_dump}"
    end

    def upload_to_tf
      # see more at https://github.com/fastlane/fastlane/issues/15390
      ENV['DELIVER_ITMSTRANSPORTER_ADDITIONAL_UPLOAD_PARAMETERS'] = '-t DAV'
      cmd = 'fastlane pilot upload --skip_submission --skip_waiting_for_build_processing'
      raise "TF uploading Failed! Command execution error: '#{cmd}'" unless system(cmd)
    end

    def update_env
      ENV[SharedValues::APP_RELEASE_VERSION] = @project_controller.version.to_s
      ENV[SharedValues::APP_RELEASE_BUILD_NUMBER] = @project_controller.build_version.to_s
      ENV[SharedValues::APP_RELEASE_VERSION_TAG] = version_dump
    end

    def push_version_bump
      cmd = "git pull origin HEAD:#{@branch}"
      raise "Git Pull Failed! Command execution error: '#{cmd}'" unless system(cmd)

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
      UI.message "going to push tag: #{curr_git_tag}"
      cmd = "git tag #{curr_git_tag} && git push --tags"
      raise "Tag push failed! Command execution error: '#{cmd}'" unless system(cmd)
    end

    def remove_existing_git_tag
      tag = existing_git_tag
      return if tag.nil?

      UI.message "going to remove tag: #{tag}"
      cmd = "git tag -d #{tag} && git push origin :refs/tags/#{tag}"
      raise "Git tag deletion failed! Command execution error: '#{cmd}'" unless system(cmd)
    end

    def curr_git_tag
      return @version.to_s unless @target_suffix

      "#{@version}_#{@target_suffix}"
    end

    def existing_git_tag
      git_tags.detect do |t|
        tag_v = t.match(/[0-9.]+/)[0]
        version_valid?(tag_v) && Version.new(tag_v) == @version
      end
    end

    def git_tags
      `git tag`.split("\n")
    end

    def version_valid?(version)
      version.to_s.match?(/^\d\.\d\.\d{1,3}$/)
    end

    def version_dump
      "#{@project_controller.version}/#{@project_controller.build_version}"
    end
  end
end
