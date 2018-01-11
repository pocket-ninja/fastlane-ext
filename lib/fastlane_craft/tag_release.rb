require_relative 'telegram_notifier'

module Fastlane
  module Actions
    class TelegramAction < Action
      include FastlaneCraft

      def self.run(params)
        puts params
      end

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
