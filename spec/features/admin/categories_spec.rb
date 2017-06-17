require 'rails_helper'

feature 'Category management' do

    store_setting
    feature_login_admin
    given(:category_1) { create(:category) }
    given(:category_2) { create(:category) }
    given(:categories) { create_list(:category, 2) }

    scenario 'should display an index of categories' do
        category_1

        visit admin_categories_path
        find('a[data-original-title="Categories"]').click
        expect(current_path).to eq admin_categories_path
        within 'h2' do
            expect(page).to have_content 'Categories'
        end
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Categories'
        end
        within 'thead tr th:first-child' do
            expect(page).to have_content 'Name'
        end
        within 'tbody tr td:first-child' do
            expect(page).to have_content category_1.name
        end
    end

    scenario 'should add a new category' do

        visit admin_categories_path
        find('.page-header a').click
        expect(current_path).to eq new_admin_category_path
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'New'
        end
        expect{
            fill_in('category_name', with: 'category #1')
            fill_in('category_description', with: 'Lorem mofo tellivizzle sit amizzle, dawg adipiscing elit. Nullizzle sapien velit, boom shackalack volutpizzle, suscipit dang, gravida vel, fo shizzle my nizzle.')
            fill_in('category_sorting', with: '0')
            fill_in('category_page_title', with: 'Lorem mofo tellivizzle sit amizzle.')
            fill_in('category_meta_description', with: 'Lorem mofo tellivizzle sit amizzle, dawg adipiscing elit. Nullizzle sapien velit.')
            find('#category_active_true').set(true)
            click_button 'Submit'
        }.to change(Category, :count).by(1)
        expect(current_path).to eq admin_categories_path
        within '.alert.alert-success' do
            expect(page).to have_content 'Category was successfully created'
        end
        within 'h2' do
            expect(page).to have_content 'Categories'
        end
    end

    scenario 'should edit a category' do
        category_2

        visit admin_categories_path
        within 'tbody' do
            first('tr').find('td:last-child').first(:link).click
        end
        expect(current_path).to eq edit_admin_category_path(category_2)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end
        fill_in('category_name', with: 'category #2')
        fill_in('category_sorting', with: '5')
        click_button 'Submit'
        expect(current_path).to eq admin_categories_path
        within '.alert.alert-success' do
            expect(page).to have_content 'Category was successfully updated'
        end
        within 'h2' do
            expect(page).to have_content 'Categories'
        end 
        category_2.reload
        expect(category_2.name).to eq 'category #2'
        expect(category_2.sorting).to eq 5
        expect(category_2.active).to eq true
    end

    scenario "should delete a category if there is more than one record" do
        categories

        visit admin_categories_path
        expect{
            within 'tbody' do
                first('tr').find('td:last-child a:last-child').click
            end
        }.to change(Category, :count).by(-1)
        within '.alert.alert-success' do
            expect(page).to have_content('Category was successfully deleted')
        end
        within 'h2' do
            expect(page).to have_content 'Categories'
        end
    end

    scenario "should not delete a category if there is only one record" do
        category_1

        visit admin_categories_path
        expect{
            within 'tbody' do
                first('tr').find('td:last-child a:last-child').click
            end
        }.to change(Category, :count).by(0)
        within '.alert.alert-warning' do
            expect(page).to have_content('Failed to delete category - you must have at least one.')
        end
        within 'h2' do
            expect(page).to have_content 'Categories'
        end
    end
end