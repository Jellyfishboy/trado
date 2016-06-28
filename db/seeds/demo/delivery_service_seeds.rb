puts '-----------------------------'
puts 'Executing delivery service seeds'.colorize(:green)

# United Kingdom
uk_country = Country.find_by_name('United Kingdom')

delivery_service_1 = DeliveryService.create(
    name: '1st class', 
    courier_name: 'Royal Mail', 
    description: 'Standard Royal Mail delivery service within 1-2 business days.',
    country_ids: [uk_country.id]
)
DeliveryServicePrice.create(
    [
        {
            code: 'RM1 500g', 
            price: '5.67', 
            description: 'Standard Royal Mail delivery service within 1-2 business days.', 
            min_weight: '0',
            max_weight: '500',
            min_length: '0',
            max_length: '150',
            min_thickness: '0',
            max_thickness: '100',
            delivery_service_id: delivery_service_1.id
        },
        {
            code: 'RM1 1kg', 
            price: '22.67', 
            description: 'Standard Royal Mail delivery service within 1-2 business days.', 
            min_weight: '0',
            max_weight: '1000',
            min_length: '0',
            max_length: '350',
            min_thickness: '0',
            max_thickness: '175',
            delivery_service_id: delivery_service_1.id
        }
    ]
)

delivery_service_2 = DeliveryService.create(
    name: 'Special Delivery', 
    courier_name: 'Royal Mail', 
    description: 'Fully tracked service. Delivery guaranteed before 1pm the next working day after dispatch for most of the UK.',
    country_ids: [uk_country.id]
)
DeliveryServicePrice.create(
    [
        {
            code: 'RM SD 500g', 
            price: '12.88', 
            description: '', 
            min_weight: '0',
            max_weight: '500',
            min_length: '0',
            max_length: '150',
            min_thickness: '0',
            max_thickness: '100',
            delivery_service_id: delivery_service_2.id
        },
        {
            code: 'RM SD 1kg', 
            price: '18.01', 
            description: '', 
            min_weight: '0',
            max_weight: '1000',
            min_length: '0',
            max_length: '350',
            min_thickness: '0',
            max_thickness: '175',
            delivery_service_id: delivery_service_2.id
        }
    ]
)

# United States
us_country = Country.find_by_name('United States')

delivery_service_3 = DeliveryService.create(
    name: 'Express Critical', 
    courier_name: 'UPS', 
    description: 'Rely on our fastest shipping service to all 50 states and Puerto Rico when every minute counts',
    country_ids: [us_country.id]
)
DeliveryServicePrice.create(
    [
        {
            code: 'UPS EXC 500', 
            price: '22.67', 
            description: '', 
            min_weight: '0',
            max_weight: '500',
            min_length: '0',
            max_length: '150',
            min_thickness: '0',
            max_thickness: '100',
            delivery_service_id: delivery_service_3.id
        },
        {
            code: 'UPS EXC 1000', 
            price: '38.99', 
            description: '', 
            min_weight: '0',
            max_weight: '1000',
            min_length: '0',
            max_length: '350',
            min_thickness: '0',
            max_thickness: '175',
            delivery_service_id: delivery_service_3.id
        }
    ]
)

delivery_service_4 = DeliveryService.create(
    name: 'Next Day', 
    courier_name: 'UPS', 
    description: 'Get guaranteed overnight delivery for day-definite shipments',
    country_ids: [us_country.id]
)
DeliveryServicePrice.create(
    [
        {
            code: 'UPS ND 500', 
            price: '35.22', 
            description: 'Rely on our fastest shipping service to all 50 states and Puerto Rico when every minute counts', 
            min_weight: '0',
            max_weight: '500',
            min_length: '0',
            max_length: '150',
            min_thickness: '0',
            max_thickness: '100',
            delivery_service_id: delivery_service_4.id
        },
        {
            code: 'UPS ND 1000', 
            price: '62.12', 
            description: 'Rely on our fastest shipping service to all 50 states and Puerto Rico when every minute counts', 
            min_weight: '0',
            max_weight: '1000',
            min_length: '0',
            max_length: '350',
            min_thickness: '0',
            max_thickness: '175',
            delivery_service_id: delivery_service_4.id
        }
    ]
)