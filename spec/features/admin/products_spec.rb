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
        within 'thead tr th:first-child' do
            expect(page).to have_content 'SKU'
        end
        within 'tbody tr td:first-child' do
            expect(page).to have_content product.sku
        end
    end
    scenario 'should add a new product'
    scenario 'should edit a product'

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

    scenario 'should delete a product'

end