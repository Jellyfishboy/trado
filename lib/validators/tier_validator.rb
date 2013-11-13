class TierValidator < ActiveModel::EachValidator
	def validate_each(record, atttribute, value)
		record.dimensions.each do |dimension|
      		if dimension.length > Tier.maximum("length_end") || dimension.weight > Tier.maximum("weight_end") || dimension.thickness > Tier.maximum("thickness_end")
        		record.errors[:base] << "There are no available tiers for the product's dimensions."
      		end
    	end
	end
end