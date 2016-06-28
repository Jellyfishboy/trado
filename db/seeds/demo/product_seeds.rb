puts '-----------------------------'
puts 'Executing product seeds'.colorize(:green)

# file = File.read('public/demo_assets/products.json')
# json = JSON.parse(file)
yaml = YAML.load_file('lib/demo_assets/products.yml')

yaml.each do |product|
    category = Category.find_by_slug(product['category'])

    # create product
    new_product = category.products.build(
        part_number: Faker::Number.number(6),
        name: product['name'],
        description: product['description'],
        short_description: product['short_description'],
        meta_description: product['meta_description'],
        page_title: product['page_title'],
        weighting: product['weighting'],
        sku: product['sku'],
        featured: product['featured'],
        single: product['single'],
        active: product['active'],
        status: 0
    )
    new_product.send :set_slug
    new_product.save(validate: false)

    # create skus
    product['skus'].each do |sku|
        new_sku = new_product.skus.create(
            price: sku['price'],
            cost_value: sku['cost_value'],
            stock: 50,
            stock_warning_level: 5,
            code: sku['code'],
            length: sku['length'],
            weight: sku['weight'],
            thickness: sku['thickness'],
            active: true
        )
        variant_type = VariantType.find_by_name(sku['variant_type'])
        SkuVariant.create(
            sku_id: new_sku.id,
            variant_type_id: variant_type.id,
            name: sku['code']
        )
    end

    img_files = Dir.chdir(Rails.root.join("lib/demo_assets/#{product['category']}/#{product['id']}/")){ Dir.glob("**/*") }
    img_files.each do |file_name|
        new_product.attachments.create(file: File.open(File.join(Rails.root, "lib/demo_assets/#{product['category']}/#{product['id']}/", file_name)))
    end
    new_product.attachments.first.update_column(:default_record, true)
    new_product.published!
end