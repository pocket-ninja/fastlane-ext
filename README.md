# fastlane-craft &nbsp; [![Build Status](https://www.bitrise.io/app/0845b4d0a78dc7db/status.svg?token=xTOEh6hV9SMcfVlY2-MjxQ&branch=master)](https://www.bitrise.io/app/0845b4d0a78dc7db)  [![Gem Version](https://badge.fury.io/rb/fastlane-craft.svg)](https://badge.fury.io/rb/fastlane-craft)

## Contents
- [Installation](#installation)
- [Telegram](#telegram)
- [Tag Release](#tag release)
- [License](#license)

## Installation

Add this line to your Gemfile:

```ruby
gem 'fastlane-craft'
```

And then execute:
```bash
$ bundle install
```
Or install it manually as:
```bash
$ gem install fastlane-craft
```

## Telegram

Notify your telegram group via fastlane with telegram_action.
Just call `telegram` action in your lane:

```ruby
lane :notify_telegram do
  fastlane_require 'fastlane-craft'
 
  telegram(
    bot_api_token: 'bot api token', # or setup FL_TELEGRAM_BOT_API_TOKEN env variable
    chat_id: 'chat id',  # or setup FL_TELEGRAM_CHAT_ID env variable
    message: 'message',
  
    # 'Markdown' or 'HTML'. It's optional. Also U can setup FL_TELEGRAM_MESSAGE_PARSE_MODE env variable
    parse_mode: 'message parse mode'
  ) 
end
```

## Tag Release

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
