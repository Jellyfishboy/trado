class TierValidator < ActiveModel::EachValidator
	def validate_each(record, attribute, value)
  		record.skus.each do |sku|
    		if sku.length > Tier.maximum("length_end") || sku.weight > Tier.maximum("weight_end") || sku.thickness > Tier.maximum("thickness_end")
      		    record.errors[:base] << "There are no available tiers for the product's SKUs."
    		end
      end
	end
end