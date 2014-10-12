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
#  menu_title               :string(255)
#  content                  :text
#  page_title               :string(255)
#  meta_description         :string(255)
#  slug                     :string(255)
#  active                   :boolean
#  template_type            :integer            default(0)
#  created_at               :datetime           not null
#  updated_at               :datetime           not null
#
class Page < ActiveRecord::Base
    attr_accessible :title, :menu_title, :content, :page_title, :meta_description, :slug, :active, :template_type

    validates :title, :content, :page_title, :meta_description,                 presence: true
    validates :title, :slug, :menu_title,                                       uniqueness: true
    validates :page_title,                                                      length: { maximum: 70, message: :too_long }
    validates :meta_description,                                                length: { maximum: 150, message: :too_long }

    enum template_type: [:standard, :contact]

    default_scope { order(title: :asc)}
    
    include ActiveScope
end
