require 'net/https'
require 'uri'

module FastlaneCraft
  HTML = 'HTML'.freeze
  MARKDOWN = 'Markdown'.freeze

  class TelegramNotifier
    def initialize(bot_api_token:, chat_id:)
      raise 'Invalid Bot Api Token' if bot_api_token.empty?
      raise 'Invalid Chat Id' if chat_id.empty?
      @bot_api_token = bot_api_token
      @chat_id = chat_id
    end

    def notify(message:, parse_mode: nil)
      uri = URI.parse("https://api.telegram.org/bot#{@bot_api_token}/sendMessage")
      params = { text: message, chat_id: @chat_id }
      params[:parse_mode] = parse_mode unless parse_mode.nil?
      Net::HTTP.post_form(uri, params)
    end
  end
end
