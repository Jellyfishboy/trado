class Attachment < ActiveRecord::Base
  attr_accessible :attachable_id, :attachable_type, :description, :file
  belongs_to :attachable, polymorphic: true, :dependent => :destroy
  mount_uploader :file, FileUploader
end
