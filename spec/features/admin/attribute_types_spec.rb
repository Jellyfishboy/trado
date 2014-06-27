require 'spec_helper'

feature 'Attribute type management' do

    store_setting
    feature_login_admin

    scenario 'should add a new attribute type' do

        visit admin_products_skus_attribute_types_path
        find('.page-header a').click
        expect(current_path).to eq new_admin_products_skus_attribute_type_path
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'New'
        end
        expect{
            fill_in('attribute_type_name', with: 'attribute type #1')
            fill_in('attribute_type_measurement', with: 'Grams')
            click_button 'Submit'
        }.to change(AttributeType, :count).by(1)
        expect(current_path).to eq admin_products_skus_attribute_types_path
        within '.alert.alert-success' do
            expect(page).to have_content 'Attribute type was successfully created.'
        end
        within 'h2' do
            expect(page).to have_content 'Attribute types'
        end
    end

    scenario 'should edit an attribute type' do
        Sku.destroy_all
        AttributeType.destroy_all
        attribute_type = create(:attribute_type)

        visit admin_products_skus_attribute_types_path
        within 'tbody' do
            first('tr').find('td:last-child').first(:link).click
        end
        expect(current_path).to eq edit_admin_products_skus_attribute_type_path(attribute_type)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end
        fill_in('attribute_type_name', with: 'attribute type #2')
        fill_in('attribute_type_measurement', with: 'Kg')
        click_button 'Submit'
        expect(current_path).to eq admin_products_skus_attribute_types_path
        within '.alert.alert-success' do
            expect(page).to have_content 'Attribute type was successfully updated.'
        end
        within 'h2' do
            expect(page).to have_content 'Attribute types'
        end 
        attribute_type.reload
        expect(attribute_type.name).to eq 'attribute type #2'
        expect(attribute_type.measurement).to eq 'Kg'
    end

    scenario "should delete an attribute type", js: true do
        attribute_type = create(:attribute_type)

        visit admin_products_skus_attribute_types_path
        expect{
            within 'tbody' do
                first('tr').find('td:last-child a:last-child').click
            end
        }.to change(AttributeType, :count).by(-1)
        within '.alert.alert-success' do
            expect(page).to have_content('Attribute type was successfully deleted.')
        end
        within 'h2' do
            expect(page).to have_content 'Attribute types'
        end
    end
end