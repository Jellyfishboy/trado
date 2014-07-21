require 'rails_helper'

feature 'Tier management' do

    store_setting
    feature_login_admin
    given(:shipping) { create(:shipping, active: true) }
    given(:tier) { create(:tier) }
    given(:tier_with_shippings) { create(:tier_with_shippings) }
    given(:tiers) { create_list(:tier, 2) }

    scenario 'should add a new tier and not display a shipping hint when shipping records are present in the database' do
        shipping

        visit admin_shippings_tiers_path
        find('.page-header a').click
        expect(current_path).to eq new_admin_shippings_tier_path
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'New'
        end
        expect{
            fill_in('tier_length_start', with: '0')
            fill_in('tier_length_end', with: '22.8')
            fill_in('tier_weight_start', with: '0')
            fill_in('tier_weight_end', with: '100.20')
            fill_in('tier_thickness_start', with: '0')
            fill_in('tier_thickness_end', with: '89.76')
            click_button 'Submit'
        }.to change(Tier, :count).by(1)
        expect(current_path).to eq admin_shippings_tiers_path
        within '.alert.alert-success' do
            expect(page).to have_content 'Tier was successfully created.'
        end
        within 'h2' do
            expect(page).to have_content 'Tiers'
        end
    end

    scenario 'should add a new tier and display a shipping hint when shipping records are not present in the database' do

        visit admin_shippings_tiers_path
        find('.page-header a').click
        expect(current_path).to eq new_admin_shippings_tier_path
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'New'
        end
        expect{
            fill_in('tier_length_start', with: '0')
            fill_in('tier_length_end', with: '22.8')
            fill_in('tier_weight_start', with: '0')
            fill_in('tier_weight_end', with: '100.20')
            fill_in('tier_thickness_start', with: '0')
            fill_in('tier_thickness_end', with: '89.76')
            click_button 'Submit'
        }.to change(Tier, :count).by(1)
        expect(current_path).to eq admin_shippings_tiers_path
        within '.alert.alert-success' do
            expect(page).to have_content 'Tier was successfully created.'
        end
        within '.alert.alert-info' do
            expect(page).to have_content 'Hint: Remember to create a shipping method record so you can start to display shipping results in your order process.'
        end
        within 'h2' do
            expect(page).to have_content 'Tiers'
        end
    end

    scenario 'should edit an tier' do
        tier_with_shippings

        visit admin_shippings_tiers_path
        within 'tbody' do
            first('tr').find('td:last-child').first(:link).click
        end
        expect(current_path).to eq edit_admin_shippings_tier_path(tier_with_shippings)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end
        fill_in('tier_length_start', with: '4.92')
        fill_in('tier_weight_end', with: '215.67')
        find('.form-last div:nth-child(3) label input[type="checkbox"]').set(false)
        click_button 'Submit'
        expect(current_path).to eq admin_shippings_tiers_path
        within '.alert.alert-success' do
            expect(page).to have_content 'Tier was successfully updated.'
        end
        within 'h2' do
            expect(page).to have_content 'Tiers'
        end 
        tier_with_shippings.reload
        expect(tier_with_shippings.length_start).to eq BigDecimal.new("4.92")
        expect(tier_with_shippings.weight_end).to eq BigDecimal.new("215.67")
        expect(tier_with_shippings.shippings.count).to eq 1
        expect(tier_with_shippings.shippings.first.name).to eq 'Royal Mail 1st class'
    end

    scenario "should delete a tier if there is more than one record" do
        tiers

        visit admin_shippings_tiers_path
        expect{
            within 'tbody' do
                first('tr').find('td:last-child a:last-child').click
            end
        }.to change(Tier, :count).by(-1)
        within '.alert.alert-success' do
            expect(page).to have_content('Tier was successfully deleted.')
        end
        within 'h2' do
            expect(page).to have_content 'Tiers'
        end
    end

    scenario "should not delete a tier if there is only one record" do
        tier

        visit admin_shippings_tiers_path
        expect{
            within 'tbody' do
                first('tr').find('td:last-child a:last-child').click
            end
        }.to change(Tier, :count).by(0)
        within '.alert.alert-warning' do
            expect(page).to have_content('Failed to delete tier - you must have at least one.')
        end
        within 'h2' do
            expect(page).to have_content 'Tiers'
        end
    end
end
