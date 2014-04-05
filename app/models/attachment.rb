# Attachment Documentation
#
# The attachment table provides support for handling file uploads throughout the application. 
# It has a polymorphic relation so can be utilised by various models.

# == Schema Information
#
# Table name: attachments
#
#  id                 :integer          not null, primary key
#  attachable_id      :integer          
#  attachable_type    :string(255)      
#  description        :string(255)      
#  file               :string(255)      
#  default            :boolean          default(false)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class Attachment < ActiveRecord::Base
  attr_accessible :attachable_id, :attachable_type, :description, :file, :default

  belongs_to :attachable, polymorphic: true

  mount_uploader :file, FileUploader

  validates :file,                  :format => { :with => %r{\.(gif|png|jpg)$}i, :message => "must be a URL for GIF, JPG or PNG image." }
  validates :file, :description,    :presence => true
  validates :description,           :length => {:minimum => 5, :message => :too_short }
  validates :default,               :uniqueness => { :scope => :attachable_id }

end
