require 'rails_helper'

feature 'Zone management' do

    store_setting
    feature_login_admin
    given(:zone) { create(:zone) }
    given(:zones) { create_list(:zone, 2) }
    given(:zone_with_country) { create(:zone_with_country) }
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

    scenario 'should add a new zone', js: true do
        country

        visit admin_zones_path
        find('.page-header a:first-child').click
        expect(current_path).to eq new_admin_zone_path
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'New'
        end
        expect{
            fill_in('zone_name', with: 'Africa')
            select_from_chosen(country.name, from: 'zone_country_ids')
            click_button 'Submit'
        }.to change(Zone, :count).by(1)

        zone = Zone.first
        expect(zone.name).to eq 'Africa'
        expect(zone.countries.first.name).to eq country.name

        expect(current_path).to eq admin_zones_path
        within '.alert.alert-success' do
            expect(page).to have_content 'Zone was successfully created.'
        end
        within 'h2' do
            expect(page).to have_content 'Zones'
        end
    end

    scenario 'should edit a zone', js: true do
        country
        zone_with_country
        
        visit admin_zones_path
        within '.page-header + .widget-sub-heading .pull-right' do
            first(:link).click
        end
        expect(zone_with_country.countries.count).to eq 2
        expect(current_path).to eq edit_admin_zone_path(zone_with_country)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end
        fill_in('zone_name', with: 'Asia')
        find('.chosen-choices li:nth-child(2) a').click
        click_button 'Submit'
        expect(current_path).to eq admin_zones_path
        within '.alert.alert-success' do
            expect(page).to have_content 'Zone was successfully updated.'
        end
        within 'h2' do
            expect(page).to have_content 'Zones'
        end 
        zone_with_country.reload
        expect(zone_with_country.name).to eq 'Asia'
        expect(zone_with_country.countries.count).to eq 1
        expect(zone_with_country.countries.first.name).to eq 'United Kingdom'
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
