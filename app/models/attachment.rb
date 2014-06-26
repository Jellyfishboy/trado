# Attachment Documentation
#
# The attachment table provides support for handling file uploads throughout the application. 
# It has a polymorphic relation so can be utilised by various models.

# == Schema Information
#
# Table name: attachments
#
#  id                     :integer          not null, primary key
#  attachable_id          :integer          
#  attachable_type        :string(255)    
#  file                   :string(255)      
#  default_record         :boolean          default(false)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class Attachment < ActiveRecord::Base
  attr_accessible :attachable_id, :attachable_type, :file, :default_record

  belongs_to :attachable,           polymorphic: true

  mount_uploader :file,             FileUploader

  validates :file,                  :format => { :with => %r{\.(gif|png|jpg|jpeg)$}i, :message => "must be a URL for GIF, JPG, JPEG or PNG image." }
  validates :file,                  presence: true, :if => :not_setting_attachment?

  default_scope order('default_record DESC')

  before_save :set_default_attachment

  # Before saving an existing attachment, if the default_record property has been changed and is set to true
  # Update all other attachment default_record properties with a false value
  #
  def set_default_attachment
    id != nil && default_record && default_record_changed? ? self.class.where('id != ?', id).update_all(default_record: false) : nil
  end

  # If the attachment is a StoreSetting or User, ignore the presence validation
  #
  # @return [Boolean] 
  def not_setting_attachment?
    return true unless attachable_type == 'StoreSetting' || attachable_type == 'User'
  end

end
