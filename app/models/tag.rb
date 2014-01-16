# Tag Documentation
#
# The tag table contains a list of tags which belong to products. These are notably used to improve SOLR search results and site SEO.

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

  has_many :taggings, :dependent => :delete_all
  has_many :products, :through => :taggings
  
end
