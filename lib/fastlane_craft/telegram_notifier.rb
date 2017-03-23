require 'net/https'
require 'uri'

module FastlaneCraft 
  HTML = 'HTML'
  MARKDOWN = 'Markdown'

  class TelegramNotifier
    def self.notify(bot_api_token:,chat_id:, message:, parse_mode: nil)
      uri = URI.parse("https://api.telegram.org/bot#{bot_api_token}/sendMessage")
      params = { text: message, chat_id: chat_id }
      params[:parse_mode] = parse_mode unless parse_mode.nil?
      Net::HTTP.post_form(uri, params)
    end
  end
end
