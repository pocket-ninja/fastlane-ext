# FastlaneCraft

[![Gem Version](https://badge.fury.io/rb/fastlane-craft.svg)](https://badge.fury.io/rb/fastlane-craft)

## Usage

Notify your telegram group via fastlane with telegram_action.
Just call `telegram` action in your lane

### examples
```ruby
lane :notify_telegram do
  fastlane_require 'fastlane-craft'
 
  telegram(
    bot_api_token: 'bot api token', # or setup FL_TELEGRAM_BOT_API_TOKEN env variable
    chat_id: 'chat id',  # or setup FL_TELEGRAM_CHAT_ID env variable
    message: 'message' 
  ) 
end
```

 Or setup FL_TELEGRAM_BOT_API_TOKEN, FL_TELEGRAM_CHAT_ID  environment variables and run the following

```ruby
lane :notify_telegram do
  fastlane_require 'fastlane-craft'
  telegram(message: 'message') 
end

```
