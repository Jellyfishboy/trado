# encoding: utf-8
class RedactorRailsDocumentUploader < CarrierWave::Uploader::Base
  include RedactorRails::Backend::CarrierWave

  def store_dir
    if Rails.env.production?
      "redactor_assets/pictures/#{model.user_id}/#{model.assetable_id}"
    else
      "uploads/redactor_assets/pictures/#{model.user_id}/#{model.assetable_id}"
    end
  end

  def extension_white_list
    RedactorRails.document_file_types
  end
end
