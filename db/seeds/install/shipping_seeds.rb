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