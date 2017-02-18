require 'net/https'
require 'uri'

class TelegramNotifier
  def self.notify(bot_api_token:,chat_id:, message:)
    uri = URI.parse("https://api.telegram.org/bot#{bot_api_token}/sendMessage")
    params = {text: message, chat_id: chat_id}
    Net::HTTP.post_form(uri, params)
  end
end
