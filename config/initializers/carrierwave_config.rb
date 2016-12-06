CarrierWave.configure do |config|

    if Rails.env.production?
        config.storage :fog
        config.fog_credentials = {
            :provider => 'AWS',
            :aws_access_key_id => Rails.application.secrets.aws_s3_id,
            :aws_secret_access_key => Rails.application.secrets.aws_s3_key,
            :region => Rails.application.secrets.aws_s3_region,
        }
        config.fog_directory = Rails.application.secrets.aws_s3_bucket
        config.asset_host = Rails.application.secrets.carrierwave_url
        config.fog_public = true
        config.fog_attributes = {
          'Cache-Control' => 'max-age=315576000',
          'x-amz-storage-class' => 'REDUCED_REDUNDANCY'
        }
    else
        config.storage = :file
    end
end