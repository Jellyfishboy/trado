require 'rails_helper'

feature 'Delivery service management' do

    store_setting
    feature_login_admin
    given(:country) { create(:country) }
    given(:delivery_service) { create(:delivery_service, active: true) }
    given(:delivery_service_with_countries) { create(:delivery_service_with_countries) }
    given(:delivery_services) { create_list(:delivery_service, 2, active: true) }
    given(:delivery_service_price) { create(:delivery_service_price, active: true, delivery_service_id: delivery_service.id) }

    scenario 'should display an index of delivery services' do
        delivery_service

        visit admin_root_path
        find('a[data-original-title="Delivery"]').click
        expect(current_path).to eq admin_delivery_services_path
        within 'h2' do
            expect(page).to have_content 'Delivery services'
        end
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Delivery services'
        end
    end

    scenario 'should display an index of delivery service prices' do
        delivery_service
        delivery_service_price        

        visit admin_delivery_services_path
        within 'thead.main-table + tbody' do
            first('tr').find('td:not(.align-left):last-child').first(:link).click
        end
        expect(current_path).to eq admin_delivery_service_delivery_service_prices_path(delivery_service)
        within '#breadcrumbs li.current' do
            expect(page).to have_content delivery_service.full_name
        end
        within 'thead tr th:first-child' do
            expect(page).to have_content 'Code'
        end
        within 'tbody tr td:first-child' do
            expect(page).to have_content delivery_service_price.code
        end
    end

    scenario 'should add a new delivery service', js: true do
        country

        visit admin_delivery_services_path
        find('.page-header a:first-child').click
        expect(current_path).to eq new_admin_delivery_service_path
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'New'
        end
        expect{
            fill_in('delivery_service_courier_name', with: 'Royal Mail')
            fill_in('delivery_service_name', with: 'Next day delivery')
            fill_in('delivery_service_description', with: 'Speedy delivery within the UK.')
            fill_in('delivery_service_tracking_url', with: 'http://test.com/{{consignment_number}}')
            select_from_chosen(country.name, from: 'delivery_service_country_ids')
            click_button 'Submit'
        }.to change(DeliveryService, :count).by(1)

        delivery_service = DeliveryService.first
        expect(delivery_service.courier_name).to eq 'Royal Mail'
        expect(delivery_service.name).to eq 'Next day delivery'
        expect(delivery_service.description).to eq 'Speedy delivery within the UK.'
        expect(delivery_service.tracking_url).to eq 'http://test.com/{{consignment_number}}'
        expect(delivery_service.countries.first.name).to eq country.name

        expect(current_path).to eq admin_delivery_services_path
        within '.alert.alert-success' do
            expect(page).to have_content 'Delivery service was successfully created.'
        end
        within 'h2' do
            expect(page).to have_content 'Delivery services'
        end
    end

    scenario 'should edit a delivery service', js: true do
        delivery_service_with_countries

        visit admin_delivery_services_path
        within 'thead.main-table + tbody' do
            first('tr').find('td:last-child a:nth-child(2)').click
        end
        expect(current_path).to eq edit_admin_delivery_service_path(delivery_service_with_countries)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end
        fill_in('delivery_service_name', with: '1st Class')
        find('.chosen-choices li:nth-child(2) a').click
        click_button 'Submit'
        expect(current_path).to eq admin_delivery_services_path
        within '.alert.alert-success' do
            expect(page).to have_content 'Delivery service was successfully updated.'
        end
        within 'h2' do
            expect(page).to have_content 'Delivery services'
        end 
        delivery_service_with_countries.reload
        expect(delivery_service_with_countries.name).to eq '1st Class'
        expect(delivery_service_with_countries.courier_name).to eq 'Royal Mail'
        expect(delivery_service_with_countries.countries.first.name).to eq 'China'
    end

    scenario "should copy the countries between delivery services", js: true do
        delivery_service_with_countries

        visit admin_delivery_services_path
        find('.page-header a:first-child').click
        expect(current_path).to eq new_admin_delivery_service_path
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'New'
        end
        expect{
            fill_in('delivery_service_courier_name', with: 'Royal Mail')
            fill_in('delivery_service_name', with: 'Next day delivery')
            fill_in('delivery_service_description', with: 'Speedy delivery within the UK.')
            find('form div:nth-child(10) p a').click
            sleep 1

            within '.modal#delivery-service-form' do
                expect(find('.modal-header h3')).to have_content "Copy delivery service countries"
                select(delivery_service_with_countries.name, from: 'delivery_service_id')
                click_button 'Submit'
            end
            sleep 1
            expect(current_path).to eq new_admin_delivery_service_path
            click_button 'Submit'
        }.to change(DeliveryService, :count).by(1)

        delivery_service = DeliveryService.find_by_name('Next day delivery')
        expect(delivery_service.courier_name).to eq 'Royal Mail'
        expect(delivery_service.name).to eq 'Next day delivery'
        expect(delivery_service.description).to eq 'Speedy delivery within the UK.'
        expect(delivery_service.countries.first.name).to eq delivery_service_with_countries.countries.last.name

        expect(current_path).to eq admin_delivery_services_path
        within '.alert.alert-success' do
            expect(page).to have_content 'Delivery service was successfully created.'
        end
        within 'h2' do
            expect(page).to have_content 'Delivery services'
        end
    end

    scenario "should delete a delivery service if there is more than one record" do
        delivery_services

        visit admin_delivery_services_path
        expect{
            within 'thead.main-table + tbody' do
                first('tr').find('td:last-child a:last-child').click
            end
        }.to change(DeliveryService, :count).by(-1)
        within '.alert.alert-success' do
            expect(page).to have_content('Delivery service was successfully deleted.')
        end
        within 'h2' do
            expect(page).to have_content 'Delivery services'
        end
    end

    scenario "should not delete a delivery service if there is only one record" do
        delivery_service

        visit admin_delivery_services_path
        expect{
            within 'thead.main-table + tbody' do
                first('tr').find('td:last-child a:last-child').click
            end
        }.to change(DeliveryService, :count).by(0)
        within '.alert.alert-warning' do
            expect(page).to have_content('Failed to delete delivery service - you must have at least one.')
        end
        within 'h2' do
            expect(page).to have_content 'Delivery services'
        end
    end
end
