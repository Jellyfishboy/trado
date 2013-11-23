CarrierWave.configure do |config|

    if Rails.env.production?
        config.storage :fog
        config.fog_credentials = {
            :provider => 'AWS', # required
            :aws_access_key_id => ENV['GIMSON_AWS_ID'], # required
            :aws_secret_access_key => ENV['GIMSON_AWS_KEY'], # required
            :region => 'eu-west-1', # optional, defaults to 'us-east-1'
        }
        config.fog_directory = "gimson-robotics-production" # required
        config.asset_host = "http://cdn0.tomdallimore.com"
        config.fog_public = true # optional, defaults to true
        config.fog_attributes = {
          'Cache-Control' => 'max-age=315576000',
          'x-amz-storage-class' => 'REDUCED_REDUNDANCY'
        }
    else
        config.storage = :file
    end
end