require 'rails_helper'

feature 'Stock management' do

    store_setting
    feature_login_admin
    given(:sku) { create(:sku, active: true) }

    scenario 'should display an index of SKUs' do
        sku

        visit admin_products_path
        within '.page-header' do
            find('a:nth-child(2)').click
        end
        expect(current_path).to eq admin_products_stock_index_path
        within 'h2' do
            expect(page).to have_content 'Stock Management'
        end
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Stock Management'
        end
        within 'thead tr th:first-child' do
            expect(page).to have_content 'SKU'
        end
        within 'tbody tr td:first-child' do
            expect(page).to have_content sku.full_sku
        end
    end

    scenario 'should add a new stock adjustment to a SKU', js: true, broken: true do
        sku

        visit admin_products_path
        within '.page-header' do
            find('a:nth-child(2)').click
        end
        sleep 1
        expect(current_path).to eq admin_products_stock_index_path
        within 'tbody' do
            first('tr').find('td:last-child a:first-child').trigger('click')
        end
        within 'h2' do
            expect(page).to have_content "#{sku.full_sku} Stock History"
        end
        within '#breadcrumbs li.current' do
            expect(page).to have_content sku.full_sku
        end
        within '.page-header' do
            find('a:first-child').click
        end
        # Start modal
        sleep 1

        within '.modal#stock-adjustment-form' do
            expect(find('.modal-header h3')).to have_content "Add stock adjustment for #{sku.full_sku}"
            fill_in('stock_adjustment_description', with: 'New stock')
            fill_in('stock_adjustment_adjustment', with: '5')
            click_button 'Submit'
        end
        sleep 1

        expect(current_path).to eq admin_products_stock_path(sku)
        within '.stock-adjustment-create-alert' do
            expect(page).to have_content "Successfully created a new stock adjustment for #{sku.full_sku}."
        end
        # End modal 

        within 'tbody tr:first-child td:nth-child(2)' do
            expect(page).to have_content 'New Stock'
        end 
        within 'tbody tr:first-child td:nth-child(3)' do
            expect(page).to have_content 5
        end   
    end
end