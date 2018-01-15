require_relative 'info_plist_controller'
require 'fastlane_core/ui/ui'

module FastlaneCraft
  class TagReleaseManager
    include FastlaneCore
    include Gem

    def initialize(scheme, info_plist, extra_info_plists, branch, tag, target_suffix = nil)
      raise 'Invalid Branch' if branch.empty?
      raise 'Invalid Scheme' if scheme.empty?
      raise 'Invalid Tag' if tag.nil? || tag.empty?

      @scheme = scheme
      @branch = branch
      @tag = tag
      @target_suffix = target_suffix
      @plist_controller = InfoPlistController.new(info_plist, extra_info_plists)
    end

    def release
      bump_version
      archive
      upload_to_tf
      @plist_controller.bump_build_version_patch
      push_version_bump
    end

    def bump_version
      msg = 'The version of the tag is less than the actual app version'
      UI.user_error! msg if tag_version < @plist_controller.version
      UI.user_error! "Tag '#{@tag}' has no suffix: '#{@target_suffix}'" unless tag_valid?
      return unless tag_version > @plist_controller.version

      @plist_controller.set_version(tag_version)
      @plist_controller.set_build_version(Version.new(tag_version.to_s + '.0'))
      UI.success "Version was successfully bumped to #{version_dump}"
    end

    def upload_to_tf
      cmd = 'fastlane pilot upload --skip_submission'
      raise "TF uploading Failed! Command execution error: '#{cmd}'" unless system(cmd)
    end

    def push_version_bump
      cmd = "git add . && git commit -m '#{version_dump}''"
      raise "Git Commit Failed! Command execution error: '#{cmd}'" unless system(cmd)

      cmd = "git push origin HEAD:#{@branch}"
      raise "Git Push Failed! Command execution error: '#{cmd}'" unless system(cmd)
    end

    def tag_version
      version_format = /[0-9.]+/
      tag = @tag.match(version_format)[0]
      Version.new(tag)
    end

    def tag_valid?
      return true if @target_suffix.nil? || @target_suffix.empty?
      @tag.end_with? @target_suffix
    end

    def archive
      cmd = "fastlane gym --scheme #{@scheme} --export_method app-store"
      raise "Archiving failed! Command execution error: '#{cmd}'" unless system(cmd)
    end

    def version_dump
      "#{@plist_controller.version}/#{@plist_controller.build_version}"
    end
  end
end
