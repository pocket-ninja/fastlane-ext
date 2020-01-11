# frozen_string_literal: true

require 'xcodeproj'

module FastlaneExt
  class ProjectController
    include Gem

    def initialize(path, schemes)
      raise 'Invalid Path' unless File.directory?(path)

      @project = Xcodeproj::Project.open(path)
      @schemes = schemes
    end

    def bump_build_version_patch
      value = build_version.to_s
      value[-1] = (value[-1].to_i + 1).to_s
      set_build_version(Version.new(value))
    end

    def set_version(version)
      @schemes.each do |s|
        set_scheme_value_for_key(s, version.to_s, version_key)
      end
    end

    def set_build_version(version)
      @schemes.each do |s|
        set_scheme_value_for_key(s, version.to_s, build_version_key)
      end
    end

    def version
      value = scheme_value_for_key(@schemes.first, version_key)
      Version.new(value)
    end

    def build_version
      value = scheme_value_for_key(@schemes.first, build_version_key)
      Version.new(value)
    end

    private

    def set_scheme_value_for_key(scheme, value, key, configuration = nil)
      target = project_target(scheme)
      target.build_configurations.each do |config|
        config.build_settings[key] = value if configuration.nil? || config.name == configuration
      end

      @project.save
    end

    def scheme_value_for_key(scheme, key, configuration = nil)
      target = project_target(scheme)
      target.build_configurations.each do |config|
        if configuration.nil? || config.name == configuration
          value = config.build_settings[key]
          return value if value
        end
      end

      nil
    end

    def project_target(scheme)
      target = @project.targets.find { |t| t.name == scheme }
      raise "Target not found for scheme: #{scheme}" unless target

      target
    end

    def version_key
      'MARKETING_VERSION'
    end

    def build_version_key
      'CURRENT_PROJECT_VERSION'
    end
  end
end
