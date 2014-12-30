# SkuVariant Documentation
#
# The sku_variant table is a HABTM relationship handler between the tags and products tables.

# == Schema Information
#
# Table name: sku_variants
#
#  id                       :integer            not null, primary key
#  name                     :string(255)
#  sku_id                   :integer
#  variant_type_id          :integer          
#  created_at               :datetime           not null
#  updated_at               :datetime           not null
#
class SkuVariant < ActiveRecord::Base
    attr_accessible :name, :sku_id, :variant_type_id

    belongs_to :sku,                                inverse_of: :variants
    belongs_to :variant_type,                       class_name: 'VariantType'

    validates :name,                                presence: true

    auto_strip_attributes :name
end
