module Fastlane
  module Actions
    class UploadDsymAction < Action
      def self.run(params)
        require 'aws-sdk-s3'

        kind = params[:kind]
        version = params[:version]
        dsym_path = params[:dSYM]
        dsym_name = File.basename(dsym_path, '.*')
        dsym_ext = File.extname(dsym_path)

        bucket = params[:space] || params[:bucket]
        acl = params[:acl]
        file_key = [dsym_name, kind, version].join('_') + dsym_ext
        file_path = params[:space] ? params[:bucket] + '/' + file_key : file_key

        client = Aws::S3::Client.new(
          access_key_id: params[:access_key],
          secret_access_key: params[:secret_access_key],
          endpoint: params[:endpoint],
          region: params[:region]
        )

        UI.message "Check whether destination bucket #{bucket} exists..💤"
        begin
          response = client.create_bucket(
            bucket: bucket,
            acl: acl
          )
          UI.message "Bucket #{bucket} created! ✨"
        rescue Aws::S3::Errors::BucketAlreadyExists
          UI.message "Bucket #{bucket} alredy exists 👌"
        end

        UI.message 'Going to upload dSYM..💤'
        File.open(dsym_path, 'r') do |body|
          response = client.put_object(
            acl: acl,
            bucket: bucket,
            key: file_path,
            body: body
          )

          UI.message "dSYM uploaded to #{file_path} ✨"
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        'Upload dSYM archive to S3 or Spaces'
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :kind,
                                       env_name: 'FL_UPLOAD_DSYM_KIND',
                                       description: "Origin of the dSYM ('Beta', 'Release', etc)",
                                       is_string: true,
                                       default_value: ENV['BITRISE_TRIGGERED_WORKFLOW_TITLE'],
                                       verify_block: proc do |value|
                                         UI.user_error!("No kind for UploadDsymAction given, pass using `kind: 'kind'`") unless value && !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :version,
                                       env_name: 'FL_UPLOAD_DSYM_VERSION',
                                       description: "Version of a constructed .ipa. (Build number '321', App version '1.2.3', etc.)",
                                       is_string: true,
                                       default_value: ENV['APP_RELEASE_BUILD_NUMBER'] || ENV['BITRISE_BUILD_NUMBER'],
                                       verify_block: proc do |value|
                                         UI.user_error!("No version for UploadDsymAction given, pass using `version: 'version'`") unless value && !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :dSYM,
                                       env_name: 'FL_UPLOAD_DSYM_PATH',
                                       description: 'Archived dSYM files',
                                       is_string: true,
                                       default_value: ENV['DSYM_OUTPUT_PATH'] || Dir['*.dSYM.zip'].first,
                                       verify_block: proc do |value|
                                         UI.user_error!("Couldn't find dSYM file at path '#{value}'") unless File.exist?(value)
                                       end),
          FastlaneCore::ConfigItem.new(key: :region,
                                       env_name: 'FL_UPLOAD_DSYM_REGION',
                                       description: 'Region for S3 or Spaces',
                                       is_string: true,
                                       default_value: 'ams3',
                                       verify_block: proc do |value|
                                         UI.user_error!("No region for UploadDsymAction given, pass using `region: 'region'`") unless value && !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :endpoint,
                                       env_name: 'FL_UPLOAD_DSYM_ENDPOINT',
                                       description: 'Endpoint for S3 or Spaces',
                                       is_string: true,
                                       default_value: 'https://ams3.digitaloceanspaces.com',
                                       verify_block: proc do |value|
                                         UI.user_error!("No Endpoint for UploadDsymAction given, pass using `endpoint: 'endpoint'`") unless value && !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :access_key,
                                       env_name: 'FL_UPLOAD_DSYM_S3_ACCESS_KEY',
                                       description: 'Access Key for S3 or Spaces',
                                       is_string: true,
                                       verify_block: proc do |value|
                                         raise "No Access Key for UploadDsymAction given, pass using `access_key: 'access_key'`".red unless value && !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :secret_access_key,
                                       env_name: 'FL_UPLOAD_DSYM_S3_SECRET_ACCESS_KEY',
                                       description: 'Secret Access Key for S3 or Spaces',
                                       is_string: true,
                                       verify_block: proc do |value|
                                         raise "No Secret Access Key for UploadDsymAction given, pass using `secret_access_key: 'secret_access_key'`".red unless value && !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :bucket,
                                       env_name: 'FL_UPLOAD_DSYM_S3_BUCKET',
                                       description: 'Bucket for S3 or Spaces',
                                       is_string: true,
                                       default_value: 'default',
                                       verify_block: proc do |value|
                                         raise "No Bucket for UploadToS3Action given, pass using `bucket: 'bucket'`".red unless value && !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :space,
                                       env_name: 'FL_UPLOAD_DSYM_SPACE',
                                       description: 'Digital Ocean Space',
                                       is_string: true,
                                       default_value: 'appcraft-dsym'),
          FastlaneCore::ConfigItem.new(key: :acl,
                                       env_name: 'FL_UPLOAD_DSYM_S3_ACL',
                                       description: 'Access level for the file',
                                       is_string: true,
                                       default_value: 'private',
                                       verify_block: proc do |value|
                                         raise "No Bucket for UploadToS3Action given, pass using `bucket: 'bucket'`".red unless value && !value.empty?
                                       end)
        ]
      end

      def self.authors
        ['https://github.com/sroik', 'https://github.com/elfenlaid']
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
