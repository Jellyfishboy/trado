# Admin data
@user = User.create(email: 'admin@example.com', password: 'admin123#')
@role = Role.create(name: 'admin')
Permission.create(user_id: @user.id, role_id: @role.id)
@store_setting = StoreSetting.create(user_id: @user.id)
Attachment.create(  attachable_id: @user.id,
                    attachable_type: 'User',
                    file: File.open(File.join(Rails.root, '/public/images/tomdallimoreprofile.jpg')),
                    default_record: false)
Attachment.create(  attachable_id: @store_setting.id,
                    attachable_type: 'StoreSetting',
                    file: File.open(File.join(Rails.root, '/public/images/tomdallimore.png')),
                    default_record: false)

# Product data
@category = Category.create(name: 'Category #1', 
                            description: 'This is your first category.', 
                            visible: true, 
                            sorting: 1000
                            )
@attribute_type = AttributeType.create( name: 'Weight', 
                                        measurement: 'g'
                                    )
@product = Product.create(  part_number: '1', 
                            name: 'Your first product', 
                            description: 'Pellentesque pimpin\' bow wow wow. Sed erizzle. For sure izzle mah nizzle dapibus turpis tempus crazy. Maurizzle pellentesque nibh izzle ghetto. Bow wow wow izzle tortor. Pellentesque eleifend rhoncizzle dizzle. In hizzle crackalackin platea dictumst. Get down get down dapibizzle. Curabitizzle tellizzle the bizzle, pretizzle yo mamma, mattizzle rizzle, eleifend vitae, nunc. Uhuh ... yih! suscipizzle. Sizzle sempizzle velit izzle purus.',
                            short_description: 'Lorem ipsizzle fizzle sit amet, consectetuer adipiscing elit. Nullam sapien velizzle, away volutpizzle, suscipit fo shizzle, gravida gangsta, away.',
                            meta_description: 'Lorem ipsizzle fizzle sit amet, consectetuer adipiscing elit. Nullam sapien velizzle, away volutpizzle, suscipit fo shizzle, gravida gangsta, away. ',
                            weighting: 1000,
                            sku: 'TRAD',
                            featured: false,
                            single: false,
                            active: true,
                            category_id: @category.id
                        )
@accessory = Accessory.create(name: 'Accessory #1', part_number: '2', price: '1.56', weight: '10', cost_value: '6.78', active: true)
Accessorisation.create(accessory_id: @accessory.id, product_id: @product.id)
@tag_1 = Tag.create(name: 'Motor')
@tag_2 = Tag.create(name: 'New')
Tagging.create(tag_id: @tag_1.id, product_id: @product.id)
Tagging.create(tag_id: @tag_2.id, product_id: @product.id)
Sku.create( code: '55', 
            length: '100', 
            weight: '20', 
            thickness: '75', 
            attribute_value: '20', 
            attribute_type_id: @attribute_type.id, 
            stock: 20, 
            stock_warning_level: 5, 
            cost_value: '5.56', 
            price: '25.82', 
            product_id: @product.id, 
            active: true
        )
Attachment.create(  attachable_id: @product.id, 
                    attachable_type: 'Product', 
                    file: File.open(File.join(Rails.root, '/spec/dummy_data/GR12-12V-planetary-gearmotor-overview.jpg')), 
                    default_record: true
                )

# Country data
@country = Country.create(name: 'United Kingdom', language: 'English', iso: 'EN')
@zone = Zone.create(name: 'EU', country_ids: [@country.id])

# Shipping data
@shipping = Shipping.create(name: 'Royal Mail 1st class', 
                            price: '5.67', 
                            description: 'Standard Royal Mail delivery service within 1-2 business days.', 
                            zone_ids: [@zone.id]
                        )
Tier.create(length_start: '0', 
            length_end: '100',
             weight_start: '0', 
             weight_end: '1000', 
             thickness_start: '0', 
             thickness_end: '100', 
             shipping_ids: [@shipping.id]
            )
