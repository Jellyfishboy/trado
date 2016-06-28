accessory = Accessory.create(
    name: 'Accessory #1', 
    part_number: '2665', 
    price: '1.56', 
    weight: '10', 
    cost_value: '6.78', 
    active: true
)
Accessorisation.create(
    accessory_id: accessory.id, 
    product_id: Product.offset(rand(Product.count)).first.id
)