require 'spec_helper'

feature 'Product management' do

    store_setting
    feature_login_admin

    scenario 'should display an index of products' do
        product = create(:product_sku, active: true)

        visit admin_root_path
        find('a[data-original-title="Products"]').click
        expect(current_path).to eq admin_products_path
        within 'h2' do
            expect(page).to have_content 'Products'
        end
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Products'
        end
    end

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
    #     script = "$('input[type=file]').show();"
    #     page.execute_script(script)
    #     expect{
    #         # Product information
    #         select(product.category.name.to_s, from: 'product_category_id')
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
    #         attach_file('product_attachments_attributes_new_attachments_file', File.expand_path("spec/dummy_data/GR12-12V-planetary-gearmotor-overview.jpg"))

    #         # SKU details
    #         fill_in('product_skus_attributes_new_skus_code', with: '25')
    #         fill_in('product_skus_attributes_new_skus_weight', with: '5')
    #         fill_in('product_skus_attributes_new_skus_length', with: '10')
    #         fill_in('product_skus_attributes_new_skus_thickness', with: '7')
    #         fill_in('product_skus_attributes_new_skus_attribute_value', with: '5')
    #         select(attribute_type.name.to_s, from: 'product_skus_attributes_new_skus_attribute_type_id')
    #         fill_in('product_skus_attributes_new_skus_stock', with: '20')
    #         fill_in('product_skus_attributes_new_skus_stock_warning_level', with: '5')
    #         fill_in('product_skus_attributes_new_skus_cost_value', with: '2.56')
    #         fill_in('product_skus_attributes_new_skus_price', with: '78.90')

    #         # Accessories
    #         # find("#product_accessory_ids_[value='#{accessory.id}']").set(true)

    #         # Related products
    #         find("#product_related_ids_[value='#{product.id}']").set(true)

    #         click_button 'Submit'


    #     }.to change(Product, :count).by(1)
    #     # expect(current_path).to eq category_product_path()
    # end

    scenario 'should edit a product', js: true do
        product = create(:product_sku, active: true, single: false)
        accessory = create(:accessory)

        visit admin_products_path
        find('.table-actions').first(:link).click
        expect(current_path).to eq edit_admin_product_path(product)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end

        fill_in('product_name', with: 'product #1 woooppeeee')
        fill_in('product_weighting', with: '10')
        fill_in('product_sku', with: 'TA')
        find('#product_single').set(true)
        find("#product_accessory_ids_").set(true)
        click_button 'Submit'
        sleep 5
        
        expect(current_path).to eq admin_products_path

        within 'h2' do
            expect(page).to have_content 'Products'
        end 
        product.reload
        expect(product.name).to eq 'product #1 woooppeeee'
        expect(product.weighting).to eq BigDecimal.new("10")
        expect(product.sku).to eq 'TA'
        expect(product.single).to eq true
        expect(product.accessories.count).to eq 1
        expect(product.accessories.first.name).to eq accessory.name
        expect(product.accessories.first.price).to eq accessory.price
    end

    scenario 'should display an index of attribute types' do
        attribute_type = create(:attribute_type)

        visit admin_products_path
        within '.page-header' do
            find(:xpath, "//a[@title='Attribute types']").click
        end
        expect(current_path).to eq admin_products_skus_attribute_types_path
        within 'h2' do
            expect(page).to have_content 'Attribute types'
        end
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Attribute types'
        end
        within 'thead tr th:first-child' do
            expect(page).to have_content 'Name'
        end
        within 'tbody tr td:first-child' do
            expect(page).to have_content attribute_type.name
        end
    end

    scenario "should delete a product", js: true do
        product = create(:product_skus, active: true)

        visit admin_products_path
        expect{
            within 'thead.main-table + tbody' do
                first('tr').find('td:last-child a:last-child').click
            end
        }.to change(Product, :count).by(-1)
        within '.alert.alert-success' do
            expect(page).to have_content('Product was successfully deleted.')
        end
        within 'h2' do
            expect(page).to have_content 'Products'
        end
    end

    scenario 'should add a stock level record to a product SKU', js: true do
        product = create(:product_sku_stock_count, active: true)
        product.reload
        sku = product.skus.first

        visit admin_products_path
        within 'thead.main-table + tbody' do
            first('tr').find('td.table-actions').first(:link).click
        end
        expect(current_path).to eq edit_admin_product_path(product)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end
        find('#sku_fields tr td:last-child a.new_stock_levels').click
        sleep 1

        within '.modal#stock-level-form' do
            expect(find('.modal-header h3')).to have_content "Stock levels for #{sku.full_sku}"
            expect(find('.modal-body p:first-child')).to have_content "Stock level total is #{sku.stock}"
            expect(find('tbody')).to have_selector('tr.tr-red', count: 0)
            expect(find('tbody')).to have_selector('tr.tr-green', count: 0)
            fill_in('stock_level_description', with: 'Description for the new stock level adjustment.')
            fill_in('stock_level_adjustment', with: '5')
            click_button 'Add'
            sleep 1

            expect(find('tbody')).to have_selector('tr.tr-green', count: 1)
        end

        sku.reload
        expect(sku.stock).to eq 15
        expect(sku.stock_levels.count).to eq 1
        expect(sku.stock_levels.first.description).to eq 'Description for the new stock level adjustment.'
        expect(sku.stock_levels.first.adjustment).to eq 5
    end

    # SKUS

    scenario 'should edit a product SKU', js: true do
        product = create(:product_sku, active: true)
        product.reload
        sku = product.skus.first

        visit admin_products_path
        within 'thead.main-table + tbody' do
            first('tr').find('td.table-actions').first(:link).click
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

    scenario 'should delete a product SKU', js: true do
        product = create(:product_skus, active: true)

        visit admin_products_path
        find('.table-actions').first(:link).click
        expect(current_path).to eq edit_admin_product_path(product)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end

        expect(find('#sku_fields')).to have_selector('tr', count: 3)
        find('#sku_fields tr:last-child td:last-child a:last-child').click
        expect(find('#sku_fields')).to have_selector('tr', count: 2)
        expect(product.skus.count).to eq 2
        within '.sku-destroy-alert' do
            expect(page).to have_content 'Successfully deleted the SKU.'
        end
        expect(current_path).to eq edit_admin_product_path(product)
    end

    scenario 'should create an error when trying to delete a product\'s last SKU', js: true do
        product = create(:product_sku, active: true)

        visit admin_products_path
        find('.table-actions').first(:link).click
        expect(current_path).to eq edit_admin_product_path(product)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end

        expect(find('#sku_fields')).to have_selector('tr', count: 1)
        find('#sku_fields tr:last-child td:last-child a:last-child').click
        expect(find('#sku_fields')).to have_selector('tr', count: 1)
        within '.sku-failed-destroy-alert' do
            expect(page).to have_content 'Failed to remove the SKU from the database (you must have at least one SKU per product).'
        end
        expect(current_path).to eq edit_admin_product_path(product)
    end

    scenario 'should add a new table row of SKU fields to the product form', js: true do
        create(:attribute_type)
        create(:tier)

        visit admin_products_path
        find('.page-header a:first-child').click
        expect(current_path).to eq new_admin_product_path
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'New'
        end

        expect(find('#sku_fields')).to have_selector('tr', count: 1)
        find('a[data-original-title="Add SKU"]').click
        expect(find('#sku_fields')).to have_selector('tr', count: 2)
    end

    scenario 'should delete a table row of SKU fields in new product, apart from last row', js: true  do
        create(:attribute_type)
        create(:tier)

        visit admin_products_path
        find('.page-header a:first-child').click
        expect(current_path).to eq new_admin_product_path
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'New'
        end

        expect(find('#sku_fields')).to have_selector('tr', count: 1)
        find('a[data-original-title="Add SKU"]').click
        expect(find('#sku_fields')).to have_selector('tr', count: 2)
        find('#sku_fields tr:last-child td:last-child a:last-child').click
        expect(find('#sku_fields')).to have_selector('tr', count: 1)
        find('#sku_fields tr:last-child td:last-child a:last-child').click
        expect(find('#sku_fields')).to have_selector('tr', count: 1)
    end

    # ATTACHMENTS

    scenario 'should delete an attachment', js: true do
        product = create(:multiple_attachment_product, active: true)

        visit admin_products_path
        find('.table-actions').first(:link).click
        expect(current_path).to eq edit_admin_product_path(product)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end

        expect(find('#attachment_fields')).to have_selector('div.current-file', count: 2)
        find('div.current-file:first-child a:last-child').click
        expect(find('#attachment_fields')).to have_selector('div.current-file', count: 1)
        expect(product.attachments.count).to eq 1
        within '.attachment-destroy-alert' do
            expect(page).to have_content 'Successfully deleted the attachment.'
        end
        expect(current_path).to eq edit_admin_product_path(product)
    end

    scenario 'should create an error when trying to delete a product\'s last attachment', js: true do
        product = create(:product_sku, active: true)

        visit admin_products_path
        find('.table-actions').first(:link).click
        expect(current_path).to eq edit_admin_product_path(product)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end

        expect(find('#attachment_fields')).to have_selector('div.current-file', count: 1)
        find('div.current-file:first-child a:last-child').click
        expect(find('#attachment_fields')).to have_selector('div.current-file', count: 1)
        within '.failed-attachment-destroy-alert' do
            expect(page).to have_content 'Failed to remove the attachment from the database (you must have at least one image attachment per product).'
        end
        expect(current_path).to eq edit_admin_product_path(product)
    end

    scenario 'should add a new attachment field to the product form', js: true do
        create(:attribute_type)
        create(:tier)

        visit admin_products_path
        find('.page-header a:first-child').click
        expect(current_path).to eq new_admin_product_path
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'New'
        end

        expect(find('#attachment_fields')).to have_selector('div.new-file', count: 1)
        find('a[data-original-title="Add attachment"]').click
        expect(find('#attachment_fields')).to have_selector('div.new-file', count: 2)
    end

    scenario 'should delete an attachment field in new product, apart from last field', js: true do
        create(:attribute_type)
        create(:tier)

        visit admin_products_path
        find('.page-header a:first-child').click
        expect(current_path).to eq new_admin_product_path
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'New'
        end

        expect(find('#attachment_fields')).to have_selector('div.new-file', count: 1)
        find('a[data-original-title="Add attachment"]').click
        expect(find('#attachment_fields')).to have_selector('div.new-file', count: 2)
        find('#attachment_fields div.new-file:first-child a:last-child').click
        expect(find('#attachment_fields')).to have_selector('div.new-file', count: 1)
        find('#attachment_fields div.new-file:first-child a:last-child').click
        expect(find('#attachment_fields')).to have_selector('div.new-file', count: 1)
    end

    scenario 'should display a warning if no shippings tiers and/or sku attribute types have been created' do
        
        visit admin_products_path
        find('.page-header a:first-child').click
        expect(current_path).to eq admin_products_path
        within '.alert.alert-warning' do
            expect(page).to have_content "You must have at least one AttributeType record before creating your first product. Create one here."
        end
    end

end