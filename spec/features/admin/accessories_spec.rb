require 'rails_helper'

feature 'Accessory management' do

    store_setting
    feature_login_admin
    given(:accessory_1) { create(:accessory) }
    given(:accessory_2) { create(:accessory, weight: 2) }

    scenario 'should display an index of accessories' do
        accessory_1

        visit admin_root_path
        find('a[data-original-title="Accessories"]').click
        expect(current_path).to eq admin_accessories_path
        within 'h2' do
            expect(page).to have_content 'Accessories'
        end
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Accessories'
        end
        within 'thead tr th:first-child' do
            expect(page).to have_content 'Part no.'
        end
        within 'tbody tr td:first-child' do
            expect(page).to have_content accessory_1.part_number
        end
    end

    scenario 'should add a new accessory' do

        visit admin_accessories_path
        find('.page-header a').click
        expect(current_path).to eq new_admin_accessory_path
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
        within '.alert.alert-success' do
            expect(page).to have_content 'Accessory was successfully created'
        end
        within 'h2' do
            expect(page).to have_content 'Accessories'
        end
    end

    scenario 'should edit an accessory' do
        accessory_2

        visit admin_accessories_path
        within 'tbody' do
            first('tr').find('td:last-child').first(:link).click
        end
        expect(current_path).to eq edit_admin_accessory_path(accessory_2)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end
        fill_in('accessory_name', with: 'accessory #2')
        fill_in('accessory_weight', with: '5.87')
        click_button 'Submit'
        expect(current_path).to eq admin_accessories_path
        within '.alert.alert-success' do
            expect(page).to have_content 'Accessory was successfully updated'
        end
        within 'h2' do
            expect(page).to have_content 'Accessories'
        end 
        accessory_2.reload
        expect(accessory_2.name).to eq 'accessory #2'
        expect(accessory_2.weight).to eq BigDecimal.new("5.87")
        expect(accessory_2.active).to eq true
    end

    scenario "should delete an accessory" do
        accessory_1

        visit admin_accessories_path
        expect{
            within 'tbody' do
                first('tr').find('td:last-child a:last-child').click
            end
        }.to change(Accessory, :count).by(-1)
        within '.alert.alert-success' do
            expect(page).to have_content('Accessory was successfully deleted')
        end
        within 'h2' do
            expect(page).to have_content 'Accessories'
        end
    end
end
