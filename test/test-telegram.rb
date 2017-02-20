#!/usr/bin/env ruby

require 'fastlane-craft/telegram_notifier'
require 'webmock/test_unit'
include Test::Unit::Assertions
include WebMock::API
WebMock.enable!

bot_api_token = "test_api_token"
chat_id = "test_chat_id"
message = "test_message"

stub_request(:post, "https://api.telegram.org/bot#{bot_api_token}/sendMessage").
  with(:body => {"chat_id"=>chat_id, "text"=>message}).
  to_return(:status => 200)

response = TelegramNotifier.notify(
  bot_api_token: bot_api_token,
  chat_id: chat_id,
  message: message
)

assert(response.code=='200', 'wrong response code assertion!')
