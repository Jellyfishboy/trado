require 'spec_helper'

feature 'Tier management' do

    store_setting
    feature_login_admin

    scenario 'should add a new tier' do

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

    scenario 'should edit an tier' do
        tier = create(:tier_with_shippings)

        visit admin_shippings_tiers_path
        within 'tbody' do
            first('tr').find('td:last-child').first(:link).click
        end
        expect(current_path).to eq edit_admin_shippings_tier_path(tier)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end
        fill_in('tier_length_start', with: '4.92')
        fill_in('tier_weight_end', with: '215.67')
        find('.form-last div:last-child label input[type="checkbox"]').set(false)
        click_button 'Submit'
        expect(current_path).to eq admin_shippings_tiers_path
        within '.alert.alert-success' do
            expect(page).to have_content 'Tier was successfully updated.'
        end
        within 'h2' do
            expect(page).to have_content 'Tiers'
        end 
        tier.reload
        expect(tier.length_start).to eq BigDecimal.new("4.92")
        expect(tier.weight_end).to eq BigDecimal.new("215.67")
        expect(tier.shippings.count).to eq 1
        expect(tier.shippings.first.name).to eq 'Royal Mail 1st class'
    end

    scenario "should delete a tier", js: true do
        tier = create(:tier)

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
end
