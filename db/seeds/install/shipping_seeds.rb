puts '-----------------------------'
puts 'Executing shipping seeds'.colorize(:green)

country = Country.create({
    name: 'United Kingdom', 
    language: 'English', 
    iso: 'EN'
})
zone = Zone.create({
    name: 'EU', 
    country_ids: [country.id]
})
shipping = Shipping.create({
    name: 'Royal Mail 1st class', 
    price: '5.67', 
    description: 'Standard Royal Mail delivery service within 1-2 business days.', 
    zone_ids: [zone.id]
})
Tier.create([
    {
        length_start: '0', 
        length_end: '100',
        weight_start: '0', 
        weight_end: '1000', 
        thickness_start: '0', 
        thickness_end: '100', 
        shipping_ids: [shipping.id]
    },
    {
        length_start: '101', 
        length_end: '200',
        weight_start: '1001', 
        weight_end: '2000', 
        thickness_start: '101', 
        thickness_end: '200', 
        shipping_ids: [shipping.id]
    }
])