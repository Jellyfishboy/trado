# encoding: utf-8

class FileUploader < CarrierWave::Uploader::Base
  include CarrierWave::Compatibility::Paperclip
  include CarrierWave::MiniMagick
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    if Rails.env.production?
      "#{model.class.to_s.underscore}/#{model.attachable_type}/#{model.attachable_id}"
    else
      "uploads/#{model.class.to_s.underscore}/#{model.attachable_type}/#{model.attachable_id}"
    end
  end

  process resize_to_fit: [640,480]

  version :large do
    process resize_to_fill: [540,380]
  end

  version :medium, :from_version => :large do 
    process resize_to_fill: [440,280]
  end

  version :small, :from_version => :medium do
    process resize_to_fill: [240,80]
  end

  version :square do
    process resize_to_fill: [150,150]
  end

  #Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    asset_path("fallback/" + version_name + "/default.png")
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
