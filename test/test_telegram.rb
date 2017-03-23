#!/usr/bin/env ruby

require_relative '../lib/fastlane_craft/telegram_notifier'
require 'webmock/test_unit'
include Test::Unit::Assertions
include FastlaneCraft
include WebMock::API
WebMock.enable!

puts

bot_api_token = 'test_api_token'
chat_id = 'test_chat_id'
message = 'test_message'
parse_mode = MARKDOWN

stub_request(:post, "https://api.telegram.org/bot#{bot_api_token}/sendMessage").
  with(:body => { 'chat_id' => chat_id, 'text' => message, 'parse_mode' => parse_mode }).
  to_return(:status => 200)

response = TelegramNotifier.notify(
  bot_api_token: bot_api_token,
  chat_id: chat_id,
  message: message,
  parse_mode: parse_mode
)

assert(response.code == '200', 'wrong response code assertion!')
