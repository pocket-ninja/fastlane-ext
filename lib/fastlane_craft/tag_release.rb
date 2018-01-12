require_relative 'tag_release_manager'

module Fastlane
  module Actions
    class TagReleaseAction < Action
      include FastlaneCraft

      def self.run(params)
        TagReleaseManager.new(
          params[:info_plist_path],
          params[:target_suffix]
        ).release
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        'Release app according to the latest tag'
      end

      def self.details
        'Release app according to the latest tag'
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :target_suffix,
            description: 'Specific target suffix',
            optional: true
          ),
          FastlaneCore::ConfigItem.new(
            key: :info_plist_path,
            description: 'target info plist path',
            verify_block: proc do |value|
              msg = 'empty info plist path'
              UI.user_error!(msg) unless value && !value.empty?
            end
          )
        ]
      end

      def self.example_code
        [
          'tag_release(info_plist_path: "/path/to/info/plist")'
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
