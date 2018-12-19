require 'plist'

module FastlaneCraft
  class InfoPlistController
    include Gem

    def initialize(info_plist, extra_info_plists = [])
      raise 'Invalid Info Plist Path' unless File.file?(info_plist)
      raise 'Invalid Extra Info Plists Paths' unless extra_info_plists.all? { |p| File.file?(p) }

      @info_plist = info_plist
      @extra_info_plists = extra_info_plists
    end

    def bump_build_version_patch
      value = build_version.to_s
      value[-1] = (value[-1].to_i + 1).to_s
      set_build_version(Version.new(value))
    end

    def set_version(version)
      info_plists.each do |path|
        set_plist_value_for(path, version.to_s, version_key)
      end
    end

    def set_build_version(version)
      info_plists.each do |path|
        set_plist_value_for(path, version.to_s, build_version_key)
      end
    end

    def version
      value = plist_value_for(@info_plist, version_key)
      Version.new(value)
    end

    def build_version
      value = plist_value_for(@info_plist, build_version_key)
      Version.new(value)
    end

    private

    def set_plist_value_for(plist_path, value, key)
      plist = Plist.parse_xml(plist_path)
      plist[key] = value
      File.write(plist_path, Plist::Emit.dump(plist))
    end

    def plist_value_for(plist_path, key)
      Plist.parse_xml(plist_path)[key]
    end

    def info_plists
      [@info_plist] + @extra_info_plists
    end

    def version_key
      'CFBundleShortVersionString'
    end

    def build_version_key
      'CFBundleVersion'
    end
  end
end
