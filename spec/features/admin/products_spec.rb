require 'spec_helper'

feature 'Product management' do

    store_setting
    feature_login_admin

    # scenario 'should display an index of products' do
    #     product = create(:product_sku, active: true)

    #     visit admin_root_path
    #     find('a[data-original-title="Products"]').click
    #     expect(current_path).to eq admin_products_path
    #     within 'h2' do
    #         expect(page).to have_content 'Products'
    #     end
    #     within '#breadcrumbs li.current' do
    #         expect(page).to have_content 'Products'
    #     end
    #     within 'thead tr th:first-child' do
    #         expect(page).to have_content 'SKU'
    #     end
    #     within 'tbody tr td:first-child' do
    #         expect(page).to have_content product.sku
    #     end
    # end

    # scenario 'should add a new product', js: true do
    #     accessory = create(:accessory)
    #     product = create(:product)
    #     attribute_type = create(:attribute_type)

    #     visit admin_products_path
    #     find('.page-header a:first-child').click
    #     expect(current_path).to eq new_admin_product_path
    #     within '#breadcrumbs li.current' do
    #         expect(page).to have_content 'New'
    #     end
    #     expect{
    #         # Product information
    #         select(product.category.id, from: 'product_category_id')
    #         fill_in('product_part_number', with: '3452')
    #         fill_in('product_sku', with: 'GA')
    #         fill_in('product_name', with: 'product #1 with minimum 10 characters')
    #         fill_in('product_short_description', with: 'Short description for product.')
    #         fill_in('product_meta_description', with: 'Meta description for product with minimum 10 characters.')
    #         fill_in('product_weighting', with: '10')
    #         fill_in('product_description', with: 'Description for product which must contain at least 20 characters.')

    #         # Additional options
    #         find('#product_single').set(true)

    #         # Attachment
    #         # attach_file('product_attachments_attributes_new_attachments_file', File.join(Rails.root, '/spec/dummy_data/GR12-12V-planetary-gearmotor-overview.jpg'))

    #         # SKU details
    #         fill_in('product_skus_attributes_new_skus_code', with: '25')
    #         fill_in('product_skus_attributes_new_skus_weight', with: '5')
    #         fill_in('product_skus_attributes_new_skus_length', with: '10')
    #         fill_in('product_skus_attributes_new_skus_thickness', with: '7')
    #         fill_in('product_skus_attributes_new_skus_attribute_value', with: '5')
    #         select(attribute_type.id, from: 'product_skus_attributes_new_skus_attribute_type_id')
    #         fill_in('product_skus_attributes_new_skus_stock', with: '20')
    #         fill_in('product_skus_attributes_new_skus_stock_warning_level', with: '5')
    #         fill_in('product_skus_attributes_new_skus_cost_value', with: '2.56')
    #         fill_in('product_skus_attributes_new_skus_price', with: '78.90')

    #         # Accessories
    #         find("#product_accessory_ids_[value='#{accessory.id}']").set(true)

    #         # Related products
    #         find("#product_related_ids_[value='#{product.id}']").set(true)

    #         click_button 'Submit'


    #     }.to change(Product, :count).by(1)
    #     # expect(current_path).to eq category_product_path()
    # end

    # scenario 'should edit a product'

    # scenario 'should display an index of attribute types' do
    #     attribute_type = create(:attribute_type)

    #     visit admin_products_path
    #     within '.page-header' do
    #         find(:xpath, "//a[@title='Attribute types']").click
    #     end
    #     expect(current_path).to eq admin_products_skus_attribute_types_path
    #     within 'h2' do
    #         expect(page).to have_content 'Attribute types'
    #     end
    #     within '#breadcrumbs li.current' do
    #         expect(page).to have_content 'Attribute types'
    #     end
    #     within 'thead tr th:first-child' do
    #         expect(page).to have_content 'Name'
    #     end
    #     within 'tbody tr td:first-child' do
    #         expect(page).to have_content attribute_type.name
    #     end
    # end

    # scenario "should delete a product", js: true do
    #     product = create(:product_skus, active: true)

    #     visit admin_products_path
    #     expect{
    #         within 'tbody' do
    #             first('tr').find('td:last-child a:last-child').click
    #         end
    #     }.to change(Product, :count).by(-1)
    #     within '.alert' do
    #         expect(page).to have_content('Product was successfully deleted.')
    #     end
    #     within 'h2' do
    #         expect(page).to have_content 'Products'
    #     end
    # end

    # scenario 'should add a new attachment field to the product form'
    # scenario 'should add a new table row of SKU fields to the product form'
    # scenario 'should add a stock level record to a product SKU'
    scenario 'should edit a product SKU', js: true do
        product = create(:product_sku, active: true)
        sku = product.skus.first

        visit admin_products_path
        within 'tbody' do
            first('tr').find('td:last-child').first(:link).click
        end
        expect(current_path).to eq edit_admin_product_path(product)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end
        find('#sku_fields tr td:last-child a:nth-child(2)').click
        sleep 1

        within '.modal#sku-form' do
            expect(find('.modal-header h3')).to have_content "Edit SKU #{sku.full_sku}"
            fill_in('sku_length', with: '10.3')
            fill_in('sku_cost_value', with: '28.98')
            fill_in('sku_price', with: '55.22')
            click_button 'Submit'
        end
        sleep 1

        expect(current_path).to eq edit_admin_product_path(product)
        within '.sku-update-alert' do
            expect(page).to have_content 'Successfully updated the SKU.'
        end
        sku.reload
        expect(sku.length).to eq BigDecimal.new("10.3")
        expect(sku.cost_value).to eq BigDecimal.new("28.98")
        expect(sku.price).to eq BigDecimal.new("55.22")
    end

end