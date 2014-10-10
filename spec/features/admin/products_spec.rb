require 'rails_helper'

feature 'Product management' do

    store_setting
    feature_login_admin
    given(:product) { create(:product_sku, active: true) }
    given(:not_single_product) { create(:product_sku, active: true, single: false) }
    given(:attribute_type) { create(:attribute_type) }
    given(:accessory) { create(:accessory) }
    given(:product_skus) { create(:product_skus, active: true) }
    given(:product_sku_stock_count) { create(:product_sku_stock_count, active: true) }
    given(:multi_attachment_product) { create(:multiple_attachment_product, active: true) }

    scenario 'should display an index of products' do
        product

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

    scenario 'should display an index of attribute types' do
        attribute_type

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

    scenario 'should add a new product (published)', js: true do
        accessory = create(:accessory)
        product_1 = create(:product_sku_attachment)
        attribute_type = create(:attribute_type)

        visit admin_products_path
        expect{
            find('.page-header a:first-child').click
        }.to change(Product, :count).by(1)
        product = Product.first
        expect(current_path).to eq edit_admin_product_path(product)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end
        # Product information
        select(product_1.category.name.to_s, from: 'product_category_id')
        fill_in('product_part_number', with: '3452')
        fill_in('product_sku', with: 'GA')
        fill_in('product_name', with: 'product #1 with minimum 10 characters')
        fill_in('product_short_description', with: 'Short description for product.')
        fill_in('product_meta_description', with: 'Meta description for product with minimum 10 characters.')
        fill_in('product_page_title', with: 'Page title for a product')
        fill_in('product_weighting', with: '10')
        fill_in('product_description', with: 'Description for product which must contain at least 20 characters.')

        # Additional options
        find('#product_single').set(true)

        # Start attachment
        find('a[data-original-title="Add attachment"]').click
        sleep 1

        within '.modal#attachment-form' do
            expect(find('.modal-header h3')).to have_content "New attachment"
            attach_file('attachment_file', File.expand_path("spec/dummy_data/GR12-12V-planetary-gearmotor-overview.jpg"))
            find('#attachment_default_record').set(true)
            click_button 'Submit'
        end
        sleep 1

        expect(current_path).to eq edit_admin_product_path(product)
        within '.attachment-create-alert' do
            expect(page).to have_content 'Successfully created an attachment.'
        end
        # End attachment

        # Start SKU
        find('a[data-original-title="Add SKU"]').click
        sleep 1

        within '.modal#sku-form' do
            expect(find('.modal-header h3')).to have_content "New SKU"
            fill_in('sku_code', with: '50')
            fill_in('sku_length', with: '10.3')
            fill_in('sku_weight', with: '50')
            fill_in('sku_thickness', with: '27.89')
            fill_in('sku_attribute_value', with: '50')
            select(attribute_type.name, from: 'sku_attribute_type_id')
            fill_in('sku_stock', with: '100')
            fill_in('sku_stock_warning_level', with: '5')
            fill_in('sku_cost_value', with: '15.22')
            fill_in('sku_price', with: '55.22')
            click_button 'Submit'
        end
        sleep 1

        expect(current_path).to eq edit_admin_product_path(product)
        within '.sku-create-alert' do
            expect(page).to have_content 'Successfully created a SKU.'
        end
        # End SKU

        # Accessories
        find("#product_accessory_ids_#{accessory.id}").set(true)

        # Related products
        find("#product_related_ids_#{product_1.id}").set(true)

        click_button 'Publish'

        expect(current_path).to eq admin_products_path
        expect(Product.all.count).to eq 2
        within 'h2' do
            expect(page).to have_content 'Products'
        end 
        within '.alert.alert-success' do
            expect(page).to have_content 'Your product has been published successfully. It is now live in your store.'
        end
    end

    scenario 'should display a warning if there are no SKU attribute types when trying to create a new product' do
        
        visit admin_products_path
        expect{
            find('.page-header a:first-child').click
        }.to_not change(Product, :count)
        expect(current_path).to eq admin_products_path
        within '.alert.alert-warning' do
            expect(page).to have_content "You must have at least one attribute type record before creating your first product. Create one <a href=\"/admin/products/skus/attribute_types/new\">now</a>."
        end
    end

    scenario 'should edit a product (draft)' do
        not_single_product
        accessory

        visit admin_products_path
        find('.table-actions').first(:link).click
        expect(current_path).to eq edit_admin_product_path(not_single_product)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end

        fill_in('product_name', with: 'product #1 woooppeeee')
        fill_in('product_weighting', with: '10')
        fill_in('product_sku', with: 'TA')
        find('#product_single').set(true)
        find("#product_accessory_ids_#{accessory.id}").set(true)
        click_button 'Save'
        sleep 5
        
        expect(current_path).to eq admin_products_path

        within 'h2' do
            expect(page).to have_content 'Products'
        end 
        within '.alert.alert-success' do
            expect(page).to have_content 'Your product has been saved successfully as a draft.'
        end
        not_single_product.reload
        expect(not_single_product.name).to eq 'product #1 woooppeeee'
        expect(not_single_product.weighting).to eq BigDecimal.new("10")
        expect(not_single_product.sku).to eq 'TA'
        expect(not_single_product.single).to eq true
        expect(not_single_product.accessories.count).to eq 1
        expect(not_single_product.accessories.first.name).to eq accessory.name
        expect(not_single_product.accessories.first.price).to eq accessory.price
    end

    scenario "should delete a product" do
        product_skus

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

    # Stock levels

    scenario 'should add a stock level record to a product SKU', js: true do
        product_sku_stock_count
        product_sku_stock_count.reload
        sku = product_sku_stock_count.skus.first

        visit admin_products_path
        within 'thead.main-table + tbody' do
            first('tr').find('td.table-actions').first(:link).click
        end
        expect(current_path).to eq edit_admin_product_path(product_sku_stock_count)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end
        find('#sku-fields tr td:last-child').first(:link).click
        sleep 1

        within '.modal#stock-level-form' do
            expect(find('.modal-header h3')).to have_content "Stock levels for #{sku.full_sku}"
            expect(find('.modal-body p:first-child')).to have_content "Stock level total is #{sku.stock}"
            expect(find('tbody')).to have_selector('tr.tr-red', count: 0)
            expect(find('tbody')).to have_selector('tr.tr-green', count: 1)
            fill_in('stock_level_description', with: 'Description for the new stock level adjustment.')
            fill_in('stock_level_adjustment', with: '5')
            click_button 'Add'
            sleep 1

            expect(find('tbody')).to have_selector('tr.tr-green', count: 2)
        end

        sku.reload
        expect(sku.stock).to eq 15
        expect(sku.stock_levels.count).to eq 2
        expect(sku.stock_levels.first.description).to eq 'Description for the new stock level adjustment.'
        expect(sku.stock_levels.first.adjustment).to eq 5
    end

    # SKUS

    scenario 'should add a new SKU to a product', js: true do
        product
        attribute_type

        visit admin_products_path
        find('.table-actions').first(:link).click
        expect(current_path).to eq edit_admin_product_path(product)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end

        find('a[data-original-title="Add SKU"]').click
        sleep 1

        within '.modal#sku-form' do
            expect(find('.modal-header h3')).to have_content "New SKU"
            fill_in('sku_code', with: '50')
            fill_in('sku_length', with: '10.3')
            fill_in('sku_weight', with: '50')
            fill_in('sku_thickness', with: '27.89')
            fill_in('sku_attribute_value', with: '50')
            select(attribute_type.name, from: 'sku_attribute_type_id')
            fill_in('sku_stock', with: '100')
            fill_in('sku_stock_warning_level', with: '5')
            fill_in('sku_cost_value', with: '15.22')
            fill_in('sku_price', with: '55.22')
            click_button 'Submit'
        end
        sleep 1

        expect(current_path).to eq edit_admin_product_path(product)
        within '.sku-create-alert' do
            expect(page).to have_content 'Successfully created a SKU.'
        end
        product.reload
        sku = product.skus.first
        expect(product.skus.count).to eq 2 
        expect(sku.length).to eq BigDecimal.new("10.3")
        expect(sku.cost_value).to eq BigDecimal.new("15.22")
        expect(sku.price).to eq BigDecimal.new("55.22")
        expect(sku.attribute_type).to eq attribute_type
    end

    scenario 'should edit a product SKU', js: true do
        product
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
        find('#sku-fields tr td:last-child a:nth-child(2)').click
        sleep 1

        within '.modal#sku-form' do
            expect(find('.modal-header h3')).to have_content "Edit #{sku.full_sku} SKU"
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
        product_skus

        visit admin_products_path
        find('.table-actions').first(:link).click
        expect(current_path).to eq edit_admin_product_path(product_skus)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end

        expect(find('#sku-fields')).to have_selector('tr', count: 3)
        find('#sku-fields tr:last-child td:last-child a:last-child').click
        expect(find('#sku-fields')).to have_selector('tr', count: 2)
        expect(product_skus.skus.count).to eq 2
        within '.sku-destroy-alert' do
            expect(page).to have_content 'Successfully deleted the SKU.'
        end
        expect(current_path).to eq edit_admin_product_path(product_skus)
    end

    # ATTACHMENTS

    scenario 'should add an attachment to a product', js: true do
        product
        attribute_type

        visit admin_products_path
        find('.table-actions').first(:link).click
        expect(current_path).to eq edit_admin_product_path(product)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end

        find('a[data-original-title="Add attachment"]').click
        sleep 1

        within '.modal#attachment-form' do
            expect(find('.modal-header h3')).to have_content "New attachment"
            attach_file('attachment_file', File.expand_path("spec/dummy_data/GR12-12V-planetary-gearmotor-overview.jpg"))
            find('#attachment_default_record').set(true)
            click_button 'Submit'
        end
        sleep 1

        expect(current_path).to eq edit_admin_product_path(product)
        within '.attachment-create-alert' do
            expect(page).to have_content 'Successfully created an attachment.'
        end
        product.reload
        attachment = product.attachments.first
        expect(product.attachments.count).to eq 2
        expect(attachment.default_record).to eq true
    end

    scenario 'should edit an attachment', js: true do
        product
        attribute_type
        attachment = product.attachments.first

        visit admin_products_path
        find('.table-actions').first(:link).click
        expect(current_path).to eq edit_admin_product_path(product)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end
        expect(attachment.default_record).to eq false

        find('#attachments div.attachments:first-child a.label-green').click
        sleep 1

        within '.modal#attachment-form' do
            expect(find('.modal-header h3')).to have_content "Edit attachment"
            find('#attachment_default_record').set(true)
            click_button 'Submit'
        end
        sleep 1

        expect(current_path).to eq edit_admin_product_path(product)
        within '.attachment-update-alert' do
            expect(page).to have_content 'Successfully updated attachment.'
        end
        attachment.reload
        expect(attachment.default_record).to eq true
    end 

    scenario 'should delete an attachment', js: true do
        multi_attachment_product

        visit admin_products_path
        find('.table-actions').first(:link).click
        expect(current_path).to eq edit_admin_product_path(multi_attachment_product)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end

        expect(find('#attachments')).to have_selector('div.attachments', count: 2)
        find('div.attachments:first-child a:last-child').trigger('click')
        expect(find('#attachments')).to have_selector('div.attachments', count: 1)
        expect(multi_attachment_product.attachments.count).to eq 1
        within '.attachment-destroy-alert' do
            expect(page).to have_content 'Successfully deleted the attachment.'
        end
        expect(current_path).to eq edit_admin_product_path(multi_attachment_product)
    end
end