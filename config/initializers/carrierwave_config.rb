CarrierWave.configure do |config|

    if Rails.env.production?
        config.storage :fog
        config.fog_credentials = {
            :provider => 'AWS',
            :aws_access_key_id => Settings.aws.s3.id,
            :aws_secret_access_key => Settings.aws.s3.key,
            :region => Settings.aws.s3.region,
        }
        config.fog_directory = Settings.aws.s3.bucket
        config.asset_host = Settings.aws.cloudfront.host.carrierwave
        config.fog_public = true
        config.fog_attributes = {
          'Cache-Control' => 'max-age=315576000',
          'x-amz-storage-class' => 'REDUCED_REDUNDANCY'
        }
    else
        config.storage = :file
    end
end