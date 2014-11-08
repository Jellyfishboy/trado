puts '-----------------------------'
Rails.logger.info 'Executing product seeds'.colorize(:green)

category = Category.create({
    name: 'Category #1', 
    description: 'This is your first category.', 
    active: true, 
    sorting: 0,
    page_title: 'Page title for your category',
    meta_description: 'Meta description for your category'
})
attribute_type = AttributeType.create({
    name: 'Size',
})
AttributeType.create([
    {
        name: 'Color'
    },
    {
        name: 'Style'
    }
])
product_1 = Product.new({
    part_number: '1', 
    name: 'Your first product', 
    description: 'Pellentesque pimpin\' bow wow wow. Sed erizzle. For sure izzle mah nizzle dapibus turpis tempus crazy. Maurizzle pellentesque nibh izzle ghetto. Bow wow wow izzle tortor. Pellentesque eleifend rhoncizzle dizzle. In hizzle crackalackin platea dictumst. Get down get down dapibizzle. Curabitizzle tellizzle the bizzle, pretizzle yo mamma, mattizzle rizzle, eleifend vitae, nunc. Uhuh ... yih! suscipizzle. Sizzle sempizzle velit izzle purus.',
    short_description: 'Lorem ipsizzle fizzle sit amet, consectetuer adipiscing elit. Nullam sapien velizzle, away volutpizzle, suscipit fo shizzle, gravida gangsta, away.',
    meta_description: 'Lorem ipsizzle fizzle sit amet, consectetuer adipiscing elit. Nullam sapien velizzle, away volutpizzle, suscipit fo shizzle, gravida gangsta, away. ',
    page_title: 'Page title for your product',
    weighting: 1000,
    sku: 'TRAD',
    featured: false,
    single: false,
    active: true,
    category_id: category.id,
    status: 1
})
product_1.send :set_slug
product_1.save(validate: false)
product_2 = Product.new({
    part_number: '2', 
    name: 'Product #2', 
    description: 'Pellentesque pimpin\' bow wow wow. Sed erizzle. For sure izzle mah nizzle dapibus turpis tempus crazy. Maurizzle pellentesque nibh izzle ghetto. Bow wow wow izzle tortor. Pellentesque eleifend rhoncizzle dizzle. In hizzle crackalackin platea dictumst. Get down get down dapibizzle. Curabitizzle tellizzle the bizzle, pretizzle yo mamma, mattizzle rizzle, eleifend vitae, nunc. Uhuh ... yih! suscipizzle. Sizzle sempizzle velit izzle purus.',
    short_description: 'Lorem ipsizzle fizzle sit amet, consectetuer adipiscing elit. Nullam sapien velizzle, away volutpizzle, suscipit fo shizzle, gravida gangsta, away.',
    meta_description: 'Lorem ipsizzle fizzle sit amet, consectetuer adipiscing elit. Nullam sapien velizzle, away volutpizzle, suscipit fo shizzle, gravida gangsta, away. ',
    page_title: 'Page title for your product',
    weighting: 2000,
    sku: 'DO',
    featured: false,
    single: true,
    active: true,
    category_id: category.id,
    status: 1    
})
product_2.send :set_slug
product_2.save(validate: false)
RelatedProduct.create(product_id: product_1.id, related_id: product_2.id)
accessory = Accessory.create({
    name: 'Accessory #1', 
    part_number: '2', 
    price: '1.56', 
    weight: '10', 
    cost_value: '6.78', 
    active: true
})
Accessorisation.create({
    accessory_id: accessory.id, 
    product_id: product_1.id
})
tag_1 = Tag.create({
    name: 'Motor'
})
tag_2 = Tag.create({
    name: 'New'
})
Tagging.create([
    {
        tag_id: tag_1.id, 
        product_id: product_1.id
    },
    {
        tag_id: tag_2.id, 
        product_id: product_1.id
    }
])
Sku.create([
    {
        code: '55', 
        length: '100', 
        weight: '20', 
        thickness: '75', 
        attribute_value: '20g', 
        attribute_type_id: attribute_type.id, 
        stock: 20, 
        stock_warning_level: 5, 
        cost_value: '5.56', 
        price: '25.82', 
        product_id: product_1.id, 
        active: true
    },
    {
        code: '33', 
        length: '128.67', 
        weight: '33', 
        thickness: '55', 
        attribute_value: '33g', 
        attribute_type_id: attribute_type.id, 
        stock: 40, 
        stock_warning_level: 5, 
        cost_value: '12.47', 
        price: '67.13', 
        product_id: product_1.id, 
        active: true
    },
    {
        code: '10', 
        length: '11.67', 
        weight: '13', 
        thickness: '15', 
        attribute_value: '13g', 
        attribute_type_id: attribute_type.id, 
        stock: 100, 
        stock_warning_level: 5, 
        cost_value: '1.47', 
        price: '7.23', 
        product_id: product_2.id, 
        active: true
    }
])
Attachment.create([
    {
        attachable_id: product_1.id, 
        attachable_type: 'Product', 
        file: File.open(File.join(Rails.root, '/spec/dummy_data/GR12-12V-planetary-gearmotor-overview.jpg')), 
        default_record: true
    },
    {
        attachable_id: product_1.id, 
        attachable_type: 'Product', 
        file: File.open(File.join(Rails.root, '/spec/dummy_data/GLA4000-S_12V-heavy-duty-actuator_homepage-overview.jpg')), 
        default_record: false
    },
    {
        attachable_id: product_2.id, 
        attachable_type: 'Product', 
        file: File.open(File.join(Rails.root, '/spec/dummy_data/GLA4000-S_12V-heavy-duty-actuator_homepage-overview.jpg')), 
        default_record: false
    }
])