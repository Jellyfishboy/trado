# RelatedProduct Documentation
#
# The related_products table is a HABTM relationship handler between products.
# It uses self joining association.

# == Schema Information
#
# Table name: related_products
#
#  id             :integer          not null, primary key
#  product_id     :integer
#  related_id     :integer          
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class RelatedProduct < ActiveRecord::Base

    attr_accessible :product_id, :related_id

    belongs_to :product

    validates :related_id,              :uniqueness => { :scope => :product_id }

end