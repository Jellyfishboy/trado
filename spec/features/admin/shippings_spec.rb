require 'spec_helper'

feature 'Shipping management' do

    store_setting
    feature_login_admin

    scenario 'should display an index of shippings' do
        shipping = create(:shipping, active: true)

        visit admin_root_path
        find('a[data-original-title="Shippings"]').click
        expect(current_path).to eq admin_shippings_path
        within 'h2' do
            expect(page).to have_content 'Shipping methods'
        end
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Shipping methods'
        end
        within 'thead tr th:first-child' do
            expect(page).to have_content 'Name'
        end
        within 'tbody tr td:first-child' do
            expect(page).to have_content shipping.name
        end
    end

    scenario 'should add a new shipping' do

        visit admin_shippings_path
        find('.page-header a:first-child').click
        expect(current_path).to eq new_admin_shipping_path
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'New'
        end
        expect{
            fill_in('shipping_name', with: 'Royal mail')
            fill_in('shipping_price', with: '4.78')
            fill_in('shipping_description', with: 'Speedy delivery within the UK.')
            click_button 'Submit'
        }.to change(Shipping, :count).by(1)
        expect(current_path).to eq admin_shippings_path
        within '.alert.alert-success' do
            expect(page).to have_content 'Shipping was successfully created.'
        end
        within 'h2' do
            expect(page).to have_content 'Shipping methods'
        end
    end

    scenario 'should edit a shipping' do
        shipping = create(:shipping_with_zones)

        visit admin_shippings_path
        within 'tbody' do
            first('tr').find('td:last-child').first(:link).click
        end
        expect(current_path).to eq edit_admin_shipping_path(shipping)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end
        fill_in('shipping_price', with: '4.92')
        find('.form-last div:last-child label input[type="checkbox"]').set(false)
        click_button 'Submit'
        expect(current_path).to eq admin_shippings_path
        within '.alert.alert-success' do
            expect(page).to have_content 'Shipping was successfully updated.'
        end
        within 'h2' do
            expect(page).to have_content 'Shipping methods'
        end 
        shipping.reload
        expect(shipping.price).to eq BigDecimal.new("4.92")
        expect(shipping.name).to eq 'Royal mail 1st class'
        expect(shipping.zones.count).to eq 1
        expect(shipping.zones.first.name).to eq 'EU'
    end

    scenario 'should display an index of tiers' do
        tier = create(:tier)

        visit admin_shippings_path
        within '.page-header' do
            find(:xpath, "//a[@title='Tiers']").click
        end
        expect(current_path).to eq admin_shippings_tiers_path
        within 'h2' do
            expect(page).to have_content 'Tiers'
        end
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Tiers'
        end
        within 'thead tr th:first-child' do
            expect(page).to have_content 'ID'
        end
        within 'tbody tr td:first-child' do
            expect(page).to have_content tier.id
        end
    end

    scenario "should delete a shipping if there is more than one record" do
        shipping = create_list(:shipping, 2, active: true)

        visit admin_shippings_path
        expect{
            within 'tbody' do
                first('tr').find('td:last-child a:last-child').click
            end
        }.to change(Shipping, :count).by(-1)
        within '.alert.alert-success' do
            expect(page).to have_content('Shipping was successfully deleted.')
        end
        within 'h2' do
            expect(page).to have_content 'Shipping methods'
        end
    end

    scenario "should not delete a shipping if there is only one record" do
        shipping = create(:shipping, active: true)

        visit admin_shippings_path
        expect{
            within 'tbody' do
                first('tr').find('td:last-child a:last-child').click
            end
        }.to change(Shipping, :count).by(0)
        within '.alert.alert-warning' do
            expect(page).to have_content('Failed to delete shipping - you must have at least one.')
        end
        within 'h2' do
            expect(page).to have_content 'Shipping methods'
        end
    end
end
