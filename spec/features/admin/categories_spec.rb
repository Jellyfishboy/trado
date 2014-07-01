require 'spec_helper'

feature 'Category management' do

    store_setting
    feature_login_admin

    scenario 'should display an index of categories' do
        category = create(:category)

        visit admin_root_path
        find('a[data-original-title="Categories"]').click
        expect(current_path).to eq admin_root_path
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
            expect(page).to have_content category.name
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
            find('#category_visible').set(true)
            click_button 'Submit'
        }.to change(Category, :count).by(1)
        expect(current_path).to eq admin_categories_path
        within '.alert.alert-success' do
            expect(page).to have_content 'Category was successfully created.'
        end
        within 'h2' do
            expect(page).to have_content 'Categories'
        end
    end

    scenario 'should edit a category' do
        category = create(:category, sorting: 0)

        visit admin_categories_path
        within 'tbody' do
            first('tr').find('td:last-child').first(:link).click
        end
        expect(current_path).to eq edit_admin_category_path(category)
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Edit'
        end
        fill_in('category_name', with: 'category #2')
        fill_in('category_sorting', with: '5')
        click_button 'Submit'
        expect(current_path).to eq admin_categories_path
        within '.alert.alert-success' do
            expect(page).to have_content 'Category was successfully updated.'
        end
        within 'h2' do
            expect(page).to have_content 'Categories'
        end 
        category.reload
        expect(category.name).to eq 'category #2'
        expect(category.sorting).to eq 5
        expect(category.visible).to eq true
    end

    scenario "should delete a category if there is more than one record" do
        category = create_list(:category, 2)

        visit admin_categories_path
        expect{
            within 'tbody' do
                first('tr').find('td:last-child a:last-child').click
            end
        }.to change(Category, :count).by(-1)
        within '.alert.alert-success' do
            expect(page).to have_content('Category was successfully deleted.')
        end
        within 'h2' do
            expect(page).to have_content 'Categories'
        end
    end

    scenario "should not delete a category if there is only one record" do
        category = create(:category)

        visit admin_categories_path
        expect{
            within 'tbody' do
                first('tr').find('td:last-child a:last-child').click
            end
        }.to change(Category, :count).by(0)
        within '.alert.alert-warning' do
            expect(page).to have_content('Failed to delete category - you must have at least one record.')
        end
        within 'h2' do
            expect(page).to have_content 'Categories'
        end
    end
end