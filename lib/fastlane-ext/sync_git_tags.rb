# frozen_string_literal: true

module Fastlane
  module Actions
    class SyncGitTags < Action
      include FastlaneExt

      def self.run(_params)
        rm_cmd = 'git tag -d $(git tag -l)'
        fetch_cmd = 'git fetch --prune --tags'
        raise "Failed to remove tags! cmd: '#{rm_cmd}'" unless system(rm_cmd)
        raise "Failed to fetch tags! cmd: '#{fetch_cmd}'" unless system(fetch_cmd)
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        'Synchronize git tags with remote'
      end

      def self.details
        'Synchronize git tags with remote'
      end

      def self.available_options
        []
      end

      def self.example_code
        [
          'sync_git_tags'
        ]
      end

      def self.authors
        %w[sroik]
      end

      def self.is_supported?(_platform)
        true
      end
    end
  end
end
