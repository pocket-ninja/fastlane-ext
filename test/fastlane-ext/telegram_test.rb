# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/fastlane-ext/telegram_notifier'
require 'webmock/test_unit'

class TelegramTests < Test::Unit::TestCase
  include Test::Unit::Assertions
  include FastlaneExt
  include WebMock::API
  WebMock.enable!

  def test_broadcast
    bot_api_token = 'test_api_token'
    chat_id = 'test_chat_id'
    message = 'test_message'
    parse_mode = MARKDOWN
    silent = true

    stub_request(:post, "https://api.telegram.org/bot#{bot_api_token}/sendMessage")
      .with(body: { 'chat_id' => chat_id, 'text' => message, 'parse_mode' => parse_mode, "disable_notification" => silent })
      .to_return(status: 200)

    notifier = TelegramNotifier.new(bot_api_token: bot_api_token, chat_id: chat_id)
    response = notifier.notify(message: message, parse_mode: parse_mode, silent: silent)

    assert(response.code == '200', 'wrong response code assertion!')
  end
end
