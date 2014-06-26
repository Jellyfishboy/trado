require 'spec_helper'

feature 'Zone management' do

    store_setting
    feature_login_admin

    scenario 'should display an index of zones' do
        zone = create(:zone)

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
        within 'tbody tr td:first-child' do
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
        zone = create(:zone_with_countries)
        
        visit admin_zones_path
        within 'tbody' do
            first('tr').find('td:last-child').first(:link).click
        end
        expect(current_path).to eq edit_admin_zone_path(zone)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end
        fill_in('zone_name', with: 'Asia')
        find('.form-last div:last-child label input[type="checkbox"]').set(false)
        click_button 'Submit'
        expect(current_path).to eq admin_zones_path
        within '.alert.alert-success' do
            expect(page).to have_content 'Zone was successfully updated.'
        end
        within 'h2' do
            expect(page).to have_content 'Zones'
        end 
        zone.reload
        expect(zone.name).to eq 'Asia'
        expect(zone.countries.count).to eq 1
        expect(zone.countries.first.name).to eq 'Jamaica'
    end

    scenario 'should display an index of countries' do
        country = create(:country)

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

    scenario "should delete a zone", js: true do
        zone = create(:zone)

        visit admin_zones_path
        expect{
            within 'tbody' do
                first('tr').find('td:last-child a:last-child').click
            end
        }.to change(Zone, :count).by(-1)
        within '.alert.alert-success' do
            expect(page).to have_content('Zone was successfully deleted.')
        end
        within 'h2' do
            expect(page).to have_content 'Zones'
        end
    end
end
