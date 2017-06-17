require 'rails_helper'

feature 'Delivery service price management' do

    store_setting
    feature_login_admin
    given(:delivery_service) { create(:delivery_service, active: true) }
    given(:delivery_service_price) { create(:delivery_service_price, active: true, delivery_service_id: delivery_service.id, code: 'RM1 1kg') }
    given(:delivery_service_prices) { create_list(:delivery_service_price, 2, active: true, delivery_service_id: delivery_service.id) }
    


    scenario 'should add a new delivery service price' do

        visit admin_delivery_service_delivery_service_prices_path(delivery_service)
        find('.page-header a:first-child').click
        expect(current_path).to eq new_admin_delivery_service_delivery_service_price_path(delivery_service)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'New'
        end
        expect{
            fill_in('delivery_service_price_code', with: 'RM1 500g')
            fill_in('delivery_service_price_price', with: '5.56')
            fill_in('delivery_service_price_description', with: 'Speedy delivery within the UK.')
            fill_in('delivery_service_price_min_weight', with: '0')
            fill_in('delivery_service_price_max_weight', with: '500')
            fill_in('delivery_service_price_min_length', with: '0')
            fill_in('delivery_service_price_max_length', with: '100')
            fill_in('delivery_service_price_min_thickness', with: '0')
            fill_in('delivery_service_price_max_thickness', with: '20')
            click_button 'Submit'
        }.to change(DeliveryServicePrice, :count).by(1)
        expect(current_path).to eq admin_delivery_service_delivery_service_prices_path(delivery_service)
        within '.alert.alert-success' do
            expect(page).to have_content 'Delivery service price was successfully created'
        end
        within 'h2' do
            expect(page).to have_content "Delivery pricing for #{delivery_service.full_name}"
        end
    end

    scenario 'should edit a delivery service price' do
        delivery_service_price

        visit admin_delivery_service_delivery_service_prices_path(delivery_service)
        within 'tbody' do
            first('tr').find('td:last-child').first(:link).click
        end
        expect(current_path).to eq edit_admin_delivery_service_delivery_service_price_path(delivery_service, delivery_service_price)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end
        fill_in('delivery_service_price_price', with: '2.55')
        fill_in('delivery_service_price_max_weight', with: '489')
        click_button 'Submit'
        expect(current_path).to eq admin_delivery_service_delivery_service_prices_path(delivery_service)
        within '.alert.alert-success' do
            expect(page).to have_content 'Delivery service price was successfully updated'
        end
        within 'h2' do
            expect(page).to have_content "Delivery pricing for #{delivery_service.full_name}"
        end 
        delivery_service_price.reload
        expect(delivery_service_price.code).to eq 'RM1 1kg'
        expect(delivery_service_price.price).to eq BigDecimal.new("2.55")
        expect(delivery_service_price.max_weight).to eq BigDecimal.new("489")
    end

    scenario "should delete a delivery service price if there is more than one record" do
        delivery_service_prices

        visit admin_delivery_service_delivery_service_prices_path(delivery_service)
        expect{
            within 'tbody' do
                first('tr').find('td:last-child a:last-child').click
            end
        }.to change(DeliveryServicePrice, :count).by(-1)
        within '.alert.alert-success' do
            expect(page).to have_content('Delivery service price was successfully deleted')
        end
        within 'h2' do
            expect(page).to have_content "Delivery pricing for #{delivery_service.full_name}"
        end
    end

    scenario "should not delete a delivery service price if there is only one record" do
        delivery_service_price

        visit admin_delivery_service_delivery_service_prices_path(delivery_service)
        expect{
            within 'tbody' do
                first('tr').find('td:last-child a:last-child').click
            end
        }.to change(DeliveryServicePrice, :count).by(0)
        within '.alert.alert-warning' do
            expect(page).to have_content('Failed to delete delivery service price - you must have at least one.')
        end
        within 'h2' do
            expect(page).to have_content "Delivery pricing for #{delivery_service.full_name}"
        end
    end
end
