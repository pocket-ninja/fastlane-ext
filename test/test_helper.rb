require 'fastlane'
require 'test/unit'
require_relative '../lib/fastlane-craft'

class Test::Unit::TestCase
  include FastlaneCraft

  def with_info_plist_file
    file = Tempfile.new(%w[info .plist])
    begin
      file.write(info_plist)
      file.close
      yield file if block_given?
    ensure
      file.unlink
    end
  end

  def info_plist
    File.read(info_plist_path)
  end

  def info_plist_path
    File.expand_path('resources/mock_info.plist', __dir__)
  end
end
