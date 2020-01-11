# fastlane-ext &nbsp; [![Build Status](https://github.com/appsurd/fastlane-ext/workflows/publish/badge.svg?branch=master)](https://github.com/appsurd/fastlane-ext/actions)  [![Gem Version](https://badge.fury.io/rb/fastlane-ext.svg)](https://badge.fury.io/rb/fastlane-ext)

## Contents
- [Installation](#installation)
- [Telegram](#telegram)
- [App Release](#app-release)
- [License](#license)

## Installation

Add this line to your Gemfile:

```ruby
gem 'fastlane-ext'
```

And then execute:
```bash
$ bundle install
```
Or install it manually as:
```bash
$ gem install fastlane-ext
```

## Telegram

Notify your telegram group via fastlane with telegram_action.
Just call `telegram` action in your lane:

```ruby
lane :notify_telegram do
  fastlane_require 'fastlane-ext'

  telegram(
    bot_api_token: 'bot api token', # or setup FL_TELEGRAM_BOT_API_TOKEN env variable
    chat_id: 'chat id',  # or setup FL_TELEGRAM_CHAT_ID env variable
    message: 'message',

    # 'Markdown' or 'HTML'. It's optional. Also U can setup FL_TELEGRAM_MESSAGE_PARSE_MODE env variable
    parse_mode: 'message parse mode'
  )
end
```

## App Release

Release the application.

First of all setup certificates using [fastlane match](https://docs.fastlane.tools/actions/match/).

Then setup credentials using `FASTLANE_USER` and `FASTLANE_PASSWORD` env variables.

To release your app run:

```ruby
lane :release do
  fastlane_require 'fastlane-ext'
  app_release(
    schemes: ['app scheme'], # the first scheme should be the one to release
    project: 'path to xcodeproj', # optional, default is './*.xcodeproj'
    branch: 'remote_branch', # optional, default is master
    version: 'version', # optional, default is ENV['VERSION']
    target_suffix: '_sfx' # optional
  )
end
```

This action will set `APP_RELEASE_VERSION` (like '1.2.3'), `APP_RELEASE_BUILD_NUMBER` (like 1.2.3.0) and `APP_RELEASE_VERSION_TAG` (like 1.2.3/1.2.3.0) env variables. 


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
