# SkuVariant Documentation
#
# The sku_variant table is a HABTM relationship handler between the tags and products tables.

# == Schema Information
#
# Table name: sku_variants
#
#  id                       :integer          not null, primary key
#  sku_id                   :integer
#  variant_type_id          :integer          
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class SkuVariant < ActiveRecord::Base
    attr_accessible :name, :sku_id, :variant_type_id

    belongs_to :sku
    belongs_to :variant_type,                       class_name: 'VariantType'

    validates :name,                        presence: true
end
