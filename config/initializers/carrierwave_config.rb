CarrierWave.configure do |config|

    if Rails.env.production?
        config.storage :fog
        config.fog_credentials = {
            :provider => 'AWS',
            :aws_access_key_id => ENV['AWS_S3_ID'],
            :aws_secret_access_key => ENV['AWS_S3_KEY'],
            :region => ENV['AWS_S3_REGION'],
        }
        config.fog_directory = ENV['AWS_S3_BUCKET']
        config.asset_host = ENV['CARRIERWAVE_URL']
        config.fog_public = true
        config.fog_attributes = {
          'Cache-Control' => 'max-age=315576000',
          'x-amz-storage-class' => 'REDUCED_REDUNDANCY'
        }
    else
        config.storage = :file
    end
end