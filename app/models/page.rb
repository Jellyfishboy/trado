# Page Documentation
#
# The page table is designed to allow users to modify content on key static pages for their storefront. 
# All pages are created when installing Trado; there is currently no option to create additional pages.
# == Schema Information
#
# Table name: pages
#
#  id               :integer          not null, primary key
#  title            :string
#  content          :text
#  page_title       :string
#  meta_description :string
#  active           :boolean          default(FALSE)
#  created_at       :datetime
#  updated_at       :datetime
#  slug             :string
#  template_type    :integer
#  menu_title       :string
#  sorting          :integer          default(0)
#

class Page < ActiveRecord::Base
    attr_accessible :title, :menu_title, :content, :page_title, :meta_description, 
    :slug, :active, :template_type, :sorting

    validates :title, :content, :page_title, :meta_description, :menu_title,                presence: true
    validates :title, :slug, :menu_title,                                                   uniqueness: true
    validates :page_title,                                                                  length: { maximum: 70, message: :too_long }
    validates :meta_description,                                                            length: { maximum: 150, message: :too_long }

    enum template_type: [:standard, :contact]

    default_scope { order(sorting: :asc) }
    
    include ActiveScope
end
