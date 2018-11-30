module Fastlane
    module Actions
      module SharedValues
        UPLOADED_S3_URL = 'UPLOAD_S3_URL'.freeze
      end

      class UploadToS3Action < Action
        def self.run(params)
          require 'aws-sdk-s3'

          local_path = params[:path]
          local_name = File.basename(local_path, )

          bucket = params[:space] || params[:bucket]
          acl = params[:acl]
          file_key = local_name
          file_path = params[:space] ? params[:bucket] + '/' + file_key : file_key

          client = Aws::S3::Client.new(
            access_key_id: params[:access_key],
            secret_access_key: params[:secret_access_key],
            endpoint: params[:endpoint],
            region: params[:region]
          )

          UI.message "Check whether destination bucket #{bucket} exists..💤"
          begin
            response = client.create_bucket({
              bucket: bucket,
              acl: 'private'
            })
            UI.message "✨ Bucket #{bucket} created! ✨"
          rescue Aws::S3::Errors::BucketAlreadyExists
            UI.message "Bucket #{bucket} alredy exists 👌"
          end

          UI.message "Going to upload file to s3..💤"
          File.open(local_path, 'r') do |body|
            response = client.put_object(
              acl: acl,
              bucket: bucket,
              key: file_path,
              body: body
            )

            s3_url = params[:endpoint] + "/" + bucket + "/" + file_path
            ENV[SharedValues::UPLOADED_S3_URL] = s3_url

            UI.message "✨ file uploaded to #{s3_url} ✨"
          end
        end

        #####################################################
        # @!group Documentation
        #####################################################

        def self.description
          "Upload file to S3 or Spaces"
        end

        def self.available_options
          [
            FastlaneCore::ConfigItem.new(key: :path,
                                         env_name: "FL_UPLOAD_S3_PATH",
                                         description: "Upload local path",
                                         is_string: true,
                                         verify_block: proc do |value|
                                          UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                         end),
            FastlaneCore::ConfigItem.new(key: :region,
                                         env_name: "FL_UPLOAD_S3_REGION",
                                         description: "Region for S3 or Spaces",
                                         is_string: true,
                                         default_value: 'ams3',
                                         verify_block: proc do |value|
                                          UI.user_error!("No region for UploadToS3Action given, pass using `region: 'region'`") unless (value and not value.empty?)
                                         end),
            FastlaneCore::ConfigItem.new(key: :endpoint,
                                         env_name: "FL_UPLOAD_S3_ENDPOINT",
                                         description: "Endpoint for S3 or Spaces",
                                         is_string: true,
                                         default_value: 'https://ams3.digitaloceanspaces.com',
                                         verify_block: proc do |value|
                                          UI.user_error!("No Endpoint for UploadToS3Action given, pass using `endpoint: 'endpoint'`") unless (value and not value.empty?)
                                         end),
            FastlaneCore::ConfigItem.new(key: :access_key,
                                         env_name: "FL_UPLOAD_S3_ACCESS_KEY",
                                         description: "Access Key for S3 or Spaces",
                                         is_string: true,
                                         verify_block: proc do |value|
                                            raise "No Access Key for UploadToS3Action given, pass using `access_key: 'access_key'`".red unless (value and not value.empty?)
                                         end),
            FastlaneCore::ConfigItem.new(key: :secret_access_key,
                                         env_name: "FL_UPLOAD_S3_SECRET_ACCESS_KEY",
                                         description: "Secret Access Key for S3 or Spaces",
                                         is_string: true,
                                         verify_block: proc do |value|
                                            raise "No Secret Access Key for UploadToS3Action given, pass using `secret_access_key: 'secret_access_key'`".red unless (value and not value.empty?)
                                         end),
            FastlaneCore::ConfigItem.new(key: :bucket,
                                         env_name: "FL_UPLOAD_S3_BUCKET",
                                         description: "Bucket for S3 or Spaces",
                                         is_string: true,
                                         verify_block: proc do |value|
                                            raise "No Bucket for UploadToS3Action given, pass using `bucket: 'bucket'`".red unless (value and not value.empty?)
                                         end),
            FastlaneCore::ConfigItem.new(key: :space,
                                         env_name: "FL_UPLOAD_S3_SPACE",
                                         description: "Digital Ocean Space",
                                         is_string: true,
                                         default_value: 'appcraft-files'),
            FastlaneCore::ConfigItem.new(key: :acl,
                                         env_name: "FL_UPLOAD_S3_ACL",
                                         description: "Access level for the file",
                                         is_string: true,
                                         default_value: "public-read",
                                         verify_block: proc do |value|
                                          raise "No Bucket for UploadToS3Action given, pass using `bucket: 'bucket'`".red unless (value and not value.empty?)
                                         end),
          ]
        end

        def self.authors
          ["https://github.com/sroik", "https://github.com/elfenlaid"]
        end

        def self.output
          ['UPLOADED_S3_URL': 'Uploaded file s3 path']
        end

        def self.is_supported?(platform)
          platform == :android || platform == :ios
        end
      end
    end
  end
