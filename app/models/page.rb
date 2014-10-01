# Page Documentation
#
# The page table is designed to allow users to modify content on key static pages for their storefront. 
# All pages are created when installing Trado; there is currently no option to create additional pages.

# == Schema Information
#
# Table name: pages
#
#  id                       :integer            not null, primary key
#  title                    :string(255)
#  content                  :text
#  page_title               :string(255)
#  meta_description         :string(255)
#  visible                  :boolean
#  created_at               :datetime           not null
#  updated_at               :datetime           not null
#
class Page < ActiveRecord::Base
    attr_accessible :title, :content, :page_title, :meta_description, :visible

    validates :title, :content, :page_title, :meta_description,             presence: true
    validates :page_title,                                                  length: { maximum: 70, message: :too_long }
    validates :meta_description,                                            length: { maximum: 160, message: :too_long }
    
    
end
