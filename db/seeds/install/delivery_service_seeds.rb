puts '-----------------------------'
puts 'Executing delivery service seeds'.colorize(:green)

uk_country = Country.find_by_name('United Kingdom')

delivery_service = DeliveryService.create({
    name: '1st class', 
    courier_name: 'Royal Mail', 
    description: 'Standard Royal Mail delivery service within 1-2 business days.',
    country_ids: [uk_country.id]
})
DeliveryServicePrice.create({
    code: 'RM1 500g', 
    price: '5.67', 
    description: 'Standard Royal Mail delivery service within 1-2 business days.', 
    min_weight: '0',
    max_weight: '500',
    min_length: '0',
    max_length: '100',
    min_thickness: '0',
    max_thickness: '50',
    delivery_service_id: delivery_service.id
    
})
DeliveryServicePrice.create({
    code: 'RM1 1kg', 
    price: '22.67', 
    description: 'Standard Royal Mail delivery service within 1-2 business days.', 
    min_weight: '0',
    max_weight: '1000',
    min_length: '0',
    max_length: '150',
    min_thickness: '0',
    max_thickness: '100',
    delivery_service_id: delivery_service.id
})
