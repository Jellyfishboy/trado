require 'rails_helper'

feature 'Product management' do

    store_setting
    feature_login_admin
    given(:product) { create(:product_sku, active: true) }
    given(:not_single_product) { create(:product_sku, active: true) }
    given(:accessory) { create(:accessory) }
    given(:product_skus) { create(:product_skus, active: true) }
    given(:size_variant_type) { create(:variant_type, name: 'Size') }
    given(:colour_variant_type) { create(:variant_type, name: 'Colour') }
    given(:sku_variant_500) { create(:sku_variant, name: '500g', variant_type_id: size_variant_type.id, sku_id: product_skus.skus.first.id) }
    given(:sku_variant_1000) { create(:sku_variant, name: '1kg', variant_type_id: size_variant_type.id, sku_id: product_skus.skus.last.id) }
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

    scenario 'should add a new product (published)', js: true, broken: true do
        accessory = create(:accessory)
        product_1 = create(:product_sku_attachment)
        colour_variant_type

        visit admin_products_path
        expect{
            find('.page-header a:first-child').click
            sleep 1
        }.to change(Product, :count).by(1)
        product = Product.where.not(id: product_1.id).first
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


        # Start attachment
        find('a#add-image').click
        sleep 1

        within '.modal#attachment-form' do
            expect(find('.modal-header h3')).to have_content "Add image"
            attach_file('attachment_file', File.expand_path("spec/dummy_data/GR12-12V-planetary-gearmotor-overview.jpg"))
            find('#attachment_default_record').set(true)
            click_button 'Submit'
        end
        sleep 1

        expect(current_path).to eq edit_admin_product_path(product)
        within '.attachment-create-alert' do
            expect(page).to have_content 'Successfully created an image.'
        end
        # End attachment

        # Start variants
        find('a#sku-variant-options-button').click
        sleep 1

        within '.modal#sku-variants-form' do
            expect(find('.modal-header h3')).to have_content "Configure variant options"
            page.execute_script("$('#colour').val('Red')")
            click_button 'Submit'
        end
        sleep 2

        within '.sku-variant-created-alert' do
            expect(page).to have_content "Successfully created 1 variant."
        end
        expect(product.skus.count).to eq 1
        expect(product.variants.count).to eq 1
        expect(product.variants.map(&:name)).to match_array(["Red"])

        find('#sku-fields tr td:last-child').first(:link).trigger('click')
        sleep 1

        within '.modal#sku-form' do
            expect(find('.modal-header h3')).to have_content "Edit variant"
            fill_in('sku_code', with: '50')
            fill_in('sku_length', with: '10.3')
            fill_in('sku_weight', with: '50')
            fill_in('sku_thickness', with: '27.89')
            fill_in('sku_stock', with: '100')
            fill_in('sku_stock_warning_level', with: '5')
            fill_in('sku_cost_value', with: '15.22')
            fill_in('sku_price', with: '55.22')
            click_button 'Submit'
        end
        sleep 1

        expect(current_path).to eq edit_admin_product_path(product)
        within '.sku-update-alert' do
            expect(page).to have_content 'Successfully updated the variant.'
        end
        sku = product.skus.first
        sku.reload
        expect(sku.length).to eq BigDecimal.new("10.3")
        expect(sku.cost_value).to eq BigDecimal.new("15.22")
        expect(sku.price).to eq BigDecimal.new("55.22")
        expect(sku.stock).to eq 100
        # End SKU

        # Accessories
        select_from_chosen(accessory.name, from: "product_accessory_ids")

        # Related products
        select_from_chosen(product_1.name, from: "product_related_ids")

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

    scenario 'should edit a product (draft)', js: true, broken: true do
        not_single_product
        accessory

        visit admin_products_path
        find('.table-actions').first(:link).click
        sleep 1
        expect(current_path).to eq edit_admin_product_path(not_single_product)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end

        fill_in('product_name', with: 'product #1 woooppeeee')
        fill_in('product_weighting', with: '10')
        fill_in('product_sku', with: 'TA')
        select_from_chosen(accessory.name, from: "product_accessory_ids")
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

    # VARIANTS

    scenario 'should add new variant options', js: true do
        colour_variant_type

        visit admin_products_path
        expect{
            find('.page-header a:first-child').click
            sleep 1
        }.to change(Product, :count).by(1)
        product = Product.first
        expect(current_path).to eq edit_admin_product_path(product)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end

        find('a#sku-variant-options-button').click
        sleep 1

        within '.modal#sku-variants-form' do
            expect(find('.modal-header h3')).to have_content "Configure variant options"
            page.execute_script("$('#colour').val('Red,Blue')")
            click_button 'Submit'
        end
        sleep 2

        within '.sku-variant-created-alert' do
            expect(page).to have_content "Successfully created 2 variants."
        end
        expect(product.variants.count).to eq 2
        expect(product.variants.map(&:name)).to match_array(["Blue", "Red"])
    end

    scenario 'should update the variant options for a product', js: true, broken: true do
        product_skus
        size_variant_type
        sku_variant_500
        sku_variant_1000

        visit admin_products_path
        find('.table-actions').first(:link).click
        expect(current_path).to eq edit_admin_product_path(product_skus)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end

        find('a#sku-variant-options-button').click
        sleep 1

        within '.modal#sku-variants-form' do
            expect(find('.modal-header h3')).to have_content "Configure variant options"
            find('.bootstrap-tagsinput .tag:first-child span').click
            click_button 'Submit'
        end
        sleep 1

        expect(product_skus.variants.count).to eq 1
        expect(product_skus.variants.map(&:name)).to match_array(['1kg'])
        within '.sku-variant-updated-alert' do
            expect(page).to have_content "Successfully deleted 1 variant."
        end
    end

    scenario 'should reset variant options for a product', js: true do
        product_skus
        size_variant_type
        sku_variant_500

        visit edit_admin_product_path(product_skus)
        sleep 1
        expect(current_path).to eq edit_admin_product_path(product_skus)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end

        find('a#sku-variant-options-button').click
        sleep 1

        within '.modal#sku-variants-form' do
            expect(find('.modal-header h3')).to have_content "Configure variant options"
        end

        within '.modal#sku-variants-form' do
            find('.modal-footer').first(:link).click
        end
        sleep 1

        expect(Sku.all.count).to eq 0
        within '.sku-variant-reset-alert' do
            expect(page).to have_content 'Successfully reset the variants for this product.'
        end
    end

    # SKUS

    scenario 'should add a new SKU to a product', js: true do
        product_skus
        size_variant_type
        sku_variant_500

        visit edit_admin_product_path(product_skus)
        sleep 1
        expect(current_path).to eq edit_admin_product_path(product_skus)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end

        find('a#add-sku-button').click
        sleep 1

        within '.modal#sku-form' do
            expect(find('.modal-header h3')).to have_content "Add variant"
            fill_in('sku_variants_attributes_0_name', with: '1kg')
            fill_in('sku_code', with: '50')
            fill_in('sku_length', with: '10.3')
            fill_in('sku_weight', with: '50')
            fill_in('sku_thickness', with: '27.89')
            fill_in('sku_stock', with: '100')
            fill_in('sku_stock_warning_level', with: '5')
            fill_in('sku_cost_value', with: '15.22')
            fill_in('sku_price', with: '55.22')
            click_button 'Submit'
        end
        sleep 1

        expect(current_path).to eq edit_admin_product_path(product_skus)
        within '.sku-created-alert' do
            expect(page).to have_content 'Successfully created a variant.'
        end
        product.reload
        sku = product_skus.skus.last
        expect(product_skus.skus.count).to eq 4
        expect(sku.length).to eq BigDecimal.new("10.3")
        expect(sku.cost_value).to eq BigDecimal.new("15.22")
        expect(sku.price).to eq BigDecimal.new("55.22")
        expect(sku.variants.first.name).to eq '1kg'
    end

    scenario 'should edit a product SKU', js: true, broken: true do
        product
        product.reload
        sku = product.skus.first

        visit admin_products_path
        sleep 1

        within 'thead.main-table + tbody' do
            first('tr').find('td.table-actions').first(:link).click
        end
        expect(current_path).to eq edit_admin_product_path(product)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end
        find('#sku-fields tr td:last-child').first(:link).trigger('click')

        within '.modal#sku-form' do
            expect(find('.modal-header h3')).to have_content "Edit variant: #{sku.code}"
            fill_in('sku_length', with: '10.3')
            fill_in('sku_cost_value', with: '28.98')
            fill_in('sku_price', with: '55.22')
            click_button 'Submit'
        end
        sleep 1

        expect(current_path).to eq edit_admin_product_path(product)
        within '.sku-updated-alert' do
            expect(page).to have_content 'Successfully updated a variant.'
        end
        
        sku.reload
        expect(sku.length).to eq BigDecimal.new("10.3")
        expect(sku.cost_value).to eq BigDecimal.new("28.98")
        expect(sku.price).to eq BigDecimal.new("55.22")
    end

    scenario 'should delete a product SKU', js: true do
        product_skus

        visit edit_admin_product_path(product_skus)
        sleep 1
        expect(current_path).to eq edit_admin_product_path(product_skus)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end

        expect(find('#sku-fields')).to have_selector('tr', count: 3)
        find('#sku-fields tr:last-child td:last-child a:last-child').trigger('click')
        expect(find('#sku-fields')).to have_selector('tr', count: 2)
        expect(product_skus.skus.count).to eq 2
        within '.sku-destroy-alert' do
            expect(page).to have_content 'Successfully deleted the variant.'
        end
        expect(current_path).to eq edit_admin_product_path(product_skus)
    end

    # ATTACHMENTS

    scenario 'should display an image from a product', js: true do
        multi_attachment_product
        attachment = multi_attachment_product.attachments.first

        visit edit_admin_product_path(multi_attachment_product)
        sleep 1
        expect(current_path).to eq edit_admin_product_path(multi_attachment_product)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end
        expect(attachment.default_record).to eq false

        find('#attachments div.attachments:first-child a.label-blue').click
        sleep 1

        within '.modal#attachment-preview-form' do
            expect(find('.modal-header h3')).to have_content attachment.file.filename
        end
    end

    scenario 'should add an image to a product', js: true, broken: true do
        product

        visit admin_products_path
        find('.table-actions').first(:link).click
        expect(current_path).to eq edit_admin_product_path(product)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end

        find('a#add-image').click
        sleep 1

        within '.modal#attachment-form' do
            expect(find('.modal-header h3')).to have_content "Add image"
            attach_file('attachment_file', File.expand_path("spec/dummy_data/GR12-12V-planetary-gearmotor-overview.jpg"))
            find('#attachment_default_record').set(true)
            click_button 'Submit'
        end
        sleep 1

        expect(current_path).to eq edit_admin_product_path(product)
        within '.attachment-create-alert' do
            expect(page).to have_content 'Successfully created an image.'
        end
        product.reload
        attachment = product.attachments.first
        expect(product.attachments.count).to eq 2
        expect(attachment.default_record).to eq true
    end

    scenario 'should edit an image', js: true, broken: true do
        multi_attachment_product
        attachment = multi_attachment_product.attachments.first

        visit admin_products_path
        find('.table-actions').first(:link).click
        expect(current_path).to eq edit_admin_product_path(multi_attachment_product)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end
        expect(attachment.default_record).to eq false

        find('#attachments div.attachments:first-child a.label-green').click
        sleep 1

        within '.modal#attachment-form' do
            expect(find('.modal-header h3')).to have_content "Edit image"
            find('#attachment_default_record').set(true)
            click_button 'Submit'
        end
        sleep 1

        expect(current_path).to eq edit_admin_product_path(product)
        within '.attachment-update-alert' do
            expect(page).to have_content 'Successfully updated image.'
        end
        attachment.reload
        expect(attachment.default_record).to eq true
    end 

    scenario 'should delete an image', js: true do
        multi_attachment_product

        visit edit_admin_product_path(multi_attachment_product)
        sleep 1
        expect(current_path).to eq edit_admin_product_path(multi_attachment_product)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end

        expect(find('#attachments')).to have_selector('div.attachments', count: 2)
        find('div.attachments:first-child a:last-child').trigger('click')
        expect(find('#attachments')).to have_selector('div.attachments', count: 1)
        expect(multi_attachment_product.attachments.count).to eq 1
        within '.attachment-destroy-alert' do
            expect(page).to have_content 'Successfully deleted the image.'
        end
        expect(current_path).to eq edit_admin_product_path(multi_attachment_product)
    end
end