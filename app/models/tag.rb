# Tag Documentation
#
# The tag table contains a list of tags which belong to products. These are notably used to improve search results and site SEO.

# == Schema Information
#
# Table name: tags
#
#  id             :integer          not null, primary key
#  name           :string(255)          
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Tag < ActiveRecord::Base

  attr_accessible :name

  has_many :taggings,                       dependent: :delete_all
  has_many :products,                       through: :taggings

  # Creates or updates the list of tags for an object
  #
  def self.add value, product_id
    unless value.nil?
      @tags = value.split(/,\s*/)   
      @tags.each do |t|
          new_tag = Tag.where(name: t).first_or_create
          Tagging.create(product_id: product_id, tag_id: new_tag.id)
      end
    end
  end

  # Deletes all tags associated to the product if the string is blank.
  # Or deletes tags not contained within the comma separated string, including tagging records.
  #
  # @return [nil]
  def self.del value, product_id
    if value.blank?
      Tag.joins(:taggings).where(taggings: { product_id: product_id }).readonly(false).destroy_all 
    else
      @tags = value.split(/,\s*/)
      Tag.where.not(name: @tags).joins(:taggings).where(taggings: { product_id: product_id }).readonly(false).destroy_all
    end
  end
end