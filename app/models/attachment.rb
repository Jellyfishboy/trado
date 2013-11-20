class Attachment < ActiveRecord::Base
  attr_accessible :attachable_id, :attachable_type, :description, :file
  belongs_to :attachable, polymorphic: true
  mount_uploader :file, FileUploader
  validates :file, :format => {
      :with => %r{\.(gif|png|jpg)$}i,
      :message => "must be a URL for GIF, JPG or PNG image."
  } # all of the above validates the attributes of products
  validates :file, :description, :presence => true
  validates :description, :length => {:minimum => 5, :message => :too_short}
  before_destroy :check_association_number

  private
  
  def check_association_number
    product = Product.find(self.attachable_id)
    if product.attachments.count < 2
        product.errors[:base] << "You must have at least one attachment per product."
        return false
    end
  end
end
