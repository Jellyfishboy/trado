# encoding: utf-8
class RedactorRailsDocumentUploader < CarrierWave::Uploader::Base
  include RedactorRails::Backend::CarrierWave

  # storage :fog
  storage :file

  def store_dir
    if Rails.env.production?
        "rte/documents/#{model.class.to_s.underscore}"
    else
        "uploads/redactor_assets/documents/#{model.id}"
    end
  end

  def extension_white_list
    RedactorRails.document_file_types
  end
end
