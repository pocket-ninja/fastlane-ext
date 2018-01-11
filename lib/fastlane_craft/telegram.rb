require_relative 'telegram_notifier'

module Fastlane
  module Actions
    class TelegramAction < Action
      include FastlaneCraft

      def self.run(params)
        TelegramNotifier.notify(
          bot_api_token: params[:bot_api_token],
          chat_id: params[:chat_id],
          message: params[:message],
          parse_mode: params[:parse_mode]
        )
      end

      def self.description
        'Send a success/error message to your Telegram group'
      end

      def self.details
        'Send a success/error message to your Telegram group'
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :bot_api_token,
            env_name: 'FL_TELEGRAM_BOT_API_TOKEN',
            description: 'API Token for telegram bot',
            verify_block: proc do |value|
              msg = "No bot API token for TelegramAction given, pass using `bot_api_token: 'token'`"
              UI.user_error!(msg) unless value && !value.empty?
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :message,
            env_name: 'FL_TELEGRAM_MESSAGE',
            description: 'The message that should be displayed on Telegram',
            optional: true
          ),
          FastlaneCore::ConfigItem.new(
            key: :chat_id,
            env_name: 'FL_TELEGRAM_CHAT_ID',
            description: 'telegram chat id',
            verify_block: proc do |value|
              msg = "No chat id for TelegramAction given, pass using `chat_id: 'chat id'`"
              UI.user_error!(msg) unless value && !value.empty?
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :parse_mode,
            env_name: 'FL_TELEGRAM_MESSAGE_PARSE_MODE',
            description: 'telegram message parse mode',
            optional: true
          )
        ]
      end

      def self.example_code
        [
          'telegram(message: "App successfully released!")',
          'telegram(
            bot_api_token: "bot api token here",
            chat_id: "telegram chat id here",
            message: "message here"
            parse_mode: "message parse mode here"
          )'
        ]
      end

      def self.authors
        %w[sroik elfenlaid]
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
