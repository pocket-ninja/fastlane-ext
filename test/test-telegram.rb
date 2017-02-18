#!/usr/bin/env ruby

require 'fastlane-craft/telegram-notifier'
require 'rspec'
include RSpec::Matchers

bot_api_token = "335185888:AAFqnMC8Z8bG3x9rJT-k14QLBMKCBMaK4aY"
chat_id = -184146275
message = "Hi There!"

response = TelegramNotifier.notify(
  bot_api_token: bot_api_token,
  chat_id: chat_id,
  message: message
)

puts response
expect(response).to_not be_nil
