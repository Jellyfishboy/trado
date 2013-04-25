PayType.transaction do
	PayType.create(:name => "Check")
	PayType.create(:name => "Credit card")
	PayType.create(:name => "Purchase order")
	PayType.create(:name => "Test")
end