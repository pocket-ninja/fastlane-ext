require_relative 'app_release_manager'

module Fastlane
  module Actions
    class AppReleaseAction < Action
      def self.run(params)
        FastlaneCraft::AppReleaseManager.new(
          params[:scheme],
          params[:info_plist],
          params[:extra_info_plists],
          params[:branch],
          params[:version],
          params[:target_suffix]
        ).release
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        'Release app according to the version'
      end

      def self.details
        'Release app according to the version'
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :scheme,
            description: 'project scheme',
            verify_block: proc do |value|
              UI.user_error!('empty scheme') if value.empty?
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :info_plist,
            description: 'target info plist path',
            verify_block: proc do |value|
              msg = 'info plist path not found'
              UI.user_error!(msg) unless File.file?(value)
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :extra_info_plists,
            description: 'extra info plists paths',
            type: Array,
            default_value: [],
            verify_block: proc do |value|
              msg = 'invalid info plists paths'
              UI.user_error!(msg) unless value.all? { |p| File.file?(p) }
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :branch,
            description: 'branch',
            default_value: 'master',
            verify_block: proc do |value|
              UI.user_error!('invalid branch') if value.empty?
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :version,
            description: 'app version (like 1.1.0)',
            optional: true
          ),
          FastlaneCore::ConfigItem.new(
            key: :target_suffix,
            description: 'Specific target suffix',
            optional: true
          )
        ]
      end

      def self.example_code
        [
          'app_release(
            scheme: "AppScheme",
            info_plist: "/path/to/info/plist"
          )',
          'app_release(
            scheme: "Application",
            info_plist: "/path/to/info/plist",
            extra_info_plists: ["plist1", "plist2"],
            branch: "master",
            version: "2.3.0",
            target_suffix: "_sfx"
          )'
        ]
      end

      def self.authors
        %w[sroik]
      end

      def self.is_supported?(platform)
        platform == :ios
      end

      def self.category
        :notifications
      end
    end
  end
end
