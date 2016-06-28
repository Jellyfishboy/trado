# Attachment Documentation
#
# The attachment table provides support for handling file uploads throughout the application. 
# It has a polymorphic relation so can be utilised by various models.
# == Schema Information
#
# Table name: attachments
#
#  id              :integer          not null, primary key
#  file            :string
#  attachable_id   :integer
#  attachable_type :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  default_record  :boolean          default(FALSE)
#

class Attachment < ActiveRecord::Base
  attr_accessible :attachable_id, :attachable_type, :file, :default_record

  belongs_to :attachable,           polymorphic: true

  mount_uploader :file,             FileUploader

  validates :file,                  format: { with: /\.(gif|jpg|png)\z/i, message: "must be a URL for GIF, JPG, JPEG or PNG image." }
  validates :file,                  presence: true, :if => :not_setting_attachment?

  after_save :set_default

  default_scope { order(default_record: :desc) }

  # Finds an attachment with the passed in parameter and updates it's default_record property true
  # Then updates all other attachments default_record proeprty who are associated to the parent object to false
  #
  # @param id [Integer]
  def set_default
    Attachment.where('id != ? AND attachable_id = ?', id, attachable.id).update_all(default_record: false) if default_record
  end

  # If the attachment is a StoreSetting or User, ignore the presence validation
  #
  # @return [Boolean] 
  def not_setting_attachment?
    return attachable_type == 'StoreSetting' || attachable_type == 'User' ? false : true 
  end

end
