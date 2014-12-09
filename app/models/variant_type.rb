# VariantType Documentation
#
# The attribute type table allows the administrator to defined attribute types for their different SKUs, e.g. Weight, Color, Size, Length etc.

# == Schema Information
#
# Table name: variant_types
#
#  id             :integer          not null, primary key
#  name           :string(255)      
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class VariantType < ActiveRecord::Base
    attr_accessible :name
    
    has_many :sku_variants
    has_many :skus,                         through: :sku_variants

    validates :name,                        presence: true
end
