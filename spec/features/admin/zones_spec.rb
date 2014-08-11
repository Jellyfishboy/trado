require 'rails_helper'

feature 'Zone management' do

    store_setting
    feature_login_admin
    given(:zone) { create(:zone) }
    given(:zones) { create_list(:zone, 2) }
    given(:zone_with_countries) { create(:zone_with_countries) }
    given(:country) { create(:country) }

    scenario 'should display an index of zones' do
        zone

        visit admin_root_path
        find('a[data-original-title="Zones"]').click
        expect(current_path).to eq admin_zones_path
        within 'h2' do
            expect(page).to have_content 'Zones'
        end
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Zones'
        end
        within 'thead tr th:first-child' do
            expect(page).to have_content 'Name'
        end
        within '.page-header + .widget-sub-heading h3' do
            expect(page).to have_content zone.name
        end
    end

    scenario 'should add a new zone' do

        visit admin_zones_path
        find('.page-header a:first-child').click
        expect(current_path).to eq new_admin_zone_path
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'New'
        end
        expect{
            fill_in('zone_name', with: 'Africa')
            click_button 'Submit'
        }.to change(Zone, :count).by(1)
        expect(current_path).to eq admin_zones_path
        within '.alert.alert-success' do
            expect(page).to have_content 'Zone was successfully created.'
        end
        within 'h2' do
            expect(page).to have_content 'Zones'
        end
    end

    scenario 'should edit an zone' do
        zone_with_countries
        
        visit admin_zones_path
        within '.page-header + .widget-sub-heading .pull-right' do
            first(:link).click
        end
        expect(current_path).to eq edit_admin_zone_path(zone_with_countries)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end
        fill_in('zone_name', with: 'Asia')
        find('table tbody tr:first-child td:last-child input[type="checkbox"]').set(false)
        click_button 'Submit'
        expect(current_path).to eq admin_zones_path
        within '.alert.alert-success' do
            expect(page).to have_content 'Zone was successfully updated.'
        end
        within 'h2' do
            expect(page).to have_content 'Zones'
        end 
        zone_with_countries.reload
        expect(zone_with_countries.name).to eq 'Asia'
        expect(zone_with_countries.countries.count).to eq 1
        expect(zone_with_countries.countries.first.name).to eq 'United Kingdom'
    end

    scenario 'should display an index of countries' do
        country

        visit admin_zones_path
        within '.page-header' do
            find(:xpath, "//a[@title='Countries']").click
        end
        expect(current_path).to eq admin_zones_countries_path
        within 'h2' do
            expect(page).to have_content 'Countries'
        end
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Countries'
        end
        within 'thead tr th:first-child' do
            expect(page).to have_content 'Name'
        end
        within 'tbody tr td:first-child' do
            expect(page).to have_content country.name
        end
    end

    scenario "should delete a zone if there is more than one record" do
        zones

        visit admin_zones_path
        expect{
            within '.page-header + .widget-sub-heading .pull-right' do
                find('a:last-child').click
            end
        }.to change(Zone, :count).by(-1)
        within '.alert.alert-success' do
            expect(page).to have_content('Zone was successfully deleted.')
        end
        within 'h2' do
            expect(page).to have_content 'Zones'
        end
    end

    scenario "should not delete a zone if there is only one record" do
        zone

        visit admin_zones_path
        expect{
            within '.page-header + .widget-sub-heading .pull-right' do
                find('a:last-child').click
            end
        }.to change(Zone, :count).by(0)
        within '.alert.alert-warning' do
            expect(page).to have_content('Failed to delete zone - you must have at least one.')
        end
        within 'h2' do
            expect(page).to have_content 'Zones'
        end
    end
end
