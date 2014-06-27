require 'spec_helper'

feature 'Country management' do

    store_setting
    feature_login_admin

    scenario 'should add a new country and not display a zone hint when zone records are present in the database' do
        create(:zone)

        visit admin_zones_countries_path
        find('.page-header a:first-child').click
        expect(current_path).to eq new_admin_zones_country_path
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'New'
        end
        expect{
            fill_in('country_name', with: 'United Kingdom')
            fill_in('country_language', with: 'English')
            fill_in('country_iso', with: 'EN')
            click_button 'Submit'
        }.to change(Country, :count).by(1)
        expect(current_path).to eq admin_zones_countries_path
        within '.alert.alert-success' do
            expect(page).to have_content 'Country was successfully created.'
        end
        within 'h2' do
            expect(page).to have_content 'Countries'
        end
    end

    scenario 'should add a new country and display a zone hint when zone records are not present in the database' do

        visit admin_zones_countries_path
        find('.page-header a:first-child').click
        expect(current_path).to eq new_admin_zones_country_path
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'New'
        end
        expect{
            fill_in('country_name', with: 'United Kingdom')
            fill_in('country_language', with: 'English')
            fill_in('country_iso', with: 'EN')
            click_button 'Submit'
        }.to change(Country, :count).by(1)
        expect(current_path).to eq admin_zones_countries_path
        within '.alert.alert-success' do
            expect(page).to have_content 'Country was successfully created.'
        end
        within '.alert.alert-info' do
            expect(page).to have_content 'Hint: Remember to create a zone record so you can start associating your countries with your shipping methods.'
        end
        within 'h2' do
            expect(page).to have_content 'Countries'
        end
    end

    scenario 'should edit a country' do
        country = create(:country, language: 'English')

        visit admin_zones_countries_path
        within 'tbody' do
            first('tr').find('td:last-child').first(:link).click
        end
        expect(current_path).to eq edit_admin_zones_country_path(country)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end
        fill_in('country_name', with: 'Canada')
        fill_in('country_iso', with: 'CA')
        click_button 'Submit'
        expect(current_path).to eq admin_zones_countries_path
        within '.alert.alert-success' do
            expect(page).to have_content 'Country was successfully updated.'
        end
        within 'h2' do
            expect(page).to have_content 'Countries'
        end 
        country.reload
        expect(country.name).to eq 'Canada'
        expect(country.language).to eq 'English'
        expect(country.iso).to eq 'CA'
    end
    
    scenario "should delete a country", js: true do
        country = create(:country)

        visit admin_zones_countries_path
        expect{
            within 'tbody' do
                first('tr').find('td:last-child a:last-child').click
            end
        }.to change(Country, :count).by(-1)
        within '.alert.alert-success' do
            expect(page).to have_content('Country was successfully deleted.')
        end
        within 'h2' do
            expect(page).to have_content 'Countries'
        end
    end
end
