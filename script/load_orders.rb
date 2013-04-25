Order.transaction do
	(1..100).each do |i|
		Order.create(:name => "Customer #{i}", :address => "#{i} Main Street",
		:email => "customer-#{i}@example.com", :pay_type => "Check")
	end
end