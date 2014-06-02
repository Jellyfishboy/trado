require 'spec_helper'

feature 'Accessory management' do

    store_setting
    feature_login_admin

    scenario 'should add a new accessory' do

        visit admin_accessories_path
        find('.page-header a').click
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'New'
        end
        expect{
            fill_in('accessory_name', with: 'accessory #1')
            fill_in('accessory_part_number', with: '2345')
            fill_in('accessory_price', with: '1')
            fill_in('accessory_cost_value', with: '2')
            fill_in('accessory_weight', with: '3.2')
            click_button 'Submit'
        }.to change(Accessory, :count).by(1)
        expect(current_path).to eq admin_accessories_path
        within '.alert' do
            expect(page).to have_content 'Accessory was successfully created.'
        end
        within 'h2' do
            expect(page).to have_content 'Accessories'
        end
    end

    scenario 'should edit an accessory' do
        accessory = create(:accessory, weight: 2)
        
        visit admin_accessories_path
        within 'tbody' do
            first('tr').find('td:last-child').first(:link).click
        end
        expect(current_path).to eq edit_admin_accessory_path(accessory)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end
        fill_in('accessory_name', with: 'accessory #2')
        fill_in('accessory_weight', with: '5.87')
        click_button 'Submit'
        expect(current_path).to eq admin_accessories_path
        within '.alert' do
            expect(page).to have_content 'Accessory was successfully updated.'
        end
        within 'h2' do
            expect(page).to have_content 'Accessories'
        end 
        accessory.reload
        expect(accessory.name).to eq 'accessory #2'
        expect(accessory.weight).to eq BigDecimal.new("5.87")
        expect(accessory.active).to eq true
    end

    scenario "should delete an accessory", js: true do
        accessory = create(:accessory)

        visit admin_accessories_path
        expect{
            within 'tbody' do
                first('tr').find('td:last-child a:last-child').click
            end
        }.to change(Accessory, :count).by(-1)
        within '.alert' do
            expect(page).to have_content('Accessory was successfully deleted.')
        end
        within 'h2' do
            expect(page).to have_content 'Accessories'
        end
    end
end
