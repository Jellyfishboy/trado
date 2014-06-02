require 'spec_helper'

feature 'Category management' do

    store_setting
    feature_login_admin

    scenario 'should add a new category' do

        visit admin_categories_path
        find('.page-header a').click
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
        within '.alert' do
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
        within '.alert' do
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

    scenario "should delete a category", js: true do
        category = create(:category)

        visit admin_categories_path
        expect{
            within 'tbody' do
                first('tr').find('td:last-child a:last-child').click
            end
            # page.driver.browser.switch_to.alert.dismiss() if ENV['FF'] == true
        }.to change(Category, :count).by(-1)
        within '.alert' do
            expect(page).to have_content('Category was successfully deleted.')
        end
        within 'h2' do
            expect(page).to have_content 'Categories'
        end
    end
end