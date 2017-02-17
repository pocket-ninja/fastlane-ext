module Fastlane
  module Actions
    class TelegramAction < Action
      def self.run(params)
        require 'net/https'
        require 'uri'

        uri = URI.parse("https://api.telegram.org/bot#{params[:bot_api_token]}/sendMessage")
        params = {text: params[:message], chat_id: params[:chat_id]}
        response = Net::HTTP.post_form(uri, params)
        puts "telegram action response: #{response}"
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Send a success/error message to your Telegram group"
      end

      def self.details
        "Send a success/error message to your Telegram group"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :bot_api_token,
                                       env_name: "FL_TELEGRAM_BOT_API_TOKEN",
                                       description: "API Token for telegram bot",
                                       verify_block: proc do |value|
                                          UI.user_error!("No bot API token for TelegramAction given, pass using `bot_api_token: 'token'`") unless (value and not value.empty?)
                                       end),
          FastlaneCore::ConfigItem.new(key: :message,
                                       env_name: "FL_TELEGRAM_MESSAGE",
                                       description: "The message that should be displayed on Telegram",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :chat_id,
                                       env_name: "FL_TELEGRAM_CHAT_ID",
                                       description: "telegram chat id",
                                       verify_block: proc do |value|
                                          UI.user_error!("No chat id for TelegramAction given, pass using `chat_id: 'chat id'`") unless (value and not value.empty?)
                                       end),
        ]
      end

      def self.example_code
        [
          'telegram(message: "App successfully released!")',
          'telegram(
                   bot_api_token: "bot api token here",
                   chat_id: "telegram chat id here",
                   message: "message here"
                   )'
        ]
      end

      def self.authors
        ["sroik", "elfenlaid"]
      end

      def self.is_supported?(platform)
        true
      end

      def self.category
        :notifications
      end

    end
  end
end
