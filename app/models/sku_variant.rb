# SkuVariant Documentation
#
# The sku_variant table is a HABTM relationship handler between the tags and products tables.
# == Schema Information
#
# Table name: sku_variants
#
#  id              :integer          not null, primary key
#  sku_id          :integer
#  variant_type_id :integer
#  name            :string
#  created_at      :datetime
#  updated_at      :datetime
#

class SkuVariant < ActiveRecord::Base
    attr_accessible :name, :sku_id, :variant_type_id

    belongs_to :sku,                                inverse_of: :variants
    belongs_to :variant_type,                       class_name: 'VariantType'

    validates :name,                                presence: true

    auto_strip_attributes :name
end
