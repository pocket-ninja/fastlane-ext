# frozen_string_literal: true

require_relative 'app_release_manager'

module Fastlane
  module Actions
    class AppReleaseAction < Action
      def self.run(params)
        FastlaneExt::AppReleaseManager.new(
          params[:schemes],
          params[:project],
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
            key: :schemes,
            description: 'schemes',
            type: Array,
            verify_block: proc do |value|
              msg = 'invalid or empty schemes'
              UI.user_error!(msg) if value.empty?
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :project,
            description: 'path to xcodeproj',
            default_value: Dir.glob('*.xcodeproj').first,
            verify_block: proc do |value|
              msg = 'xcodeproj not found'
              UI.user_error!(msg) unless File.directory?(value)
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
            schemes: ["AppScheme", "AppExtension"]
          )',
          'app_release(
            schemes: ["AppScheme", "AppExtension"],
            project: "/path/to/xcodeproj",
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
