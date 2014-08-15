require 'rails_helper'

feature 'Order management' do
    
    store_setting
    feature_login_admin
    given(:undispatched) { create(:undispatched_complete_order) }
    given(:pending) { create(:pending_order) }
    given(:complete) { create(:complete_order) }
    given(:build_dispatch) { build(:edit_dispatch_order) }


    scenario 'should display an index of orders' do
        undispatched
        pending

        visit admin_root_path
        find('a[data-original-title="Orders"]').click
        expect(current_path).to eq admin_orders_path
        within 'h2' do
            expect(page).to have_content 'Orders'
        end
        within '#breadcrumbs li.current' do
            expect(page).to have_content 'Orders'
        end
        within 'thead tr th:first-child' do
            expect(page).to have_content 'Order no.'
        end
        within 'tbody tr:first-child td:last-child' do
            expect(page).to have_selector('a', count: 1)
        end
        within 'tbody tr:last-child td:last-child' do
            expect(page).to have_selector('a', count: 2)
        end
    end

    scenario 'should display a pending order' do
        pending

        visit admin_orders_path
        find('tbody tr td:last-child a:first-child').click
        expect(current_path).to eq admin_order_path(pending)
        within 'h2' do
            expect(page).to have_content "Order ##{pending.id}"
        end
        within '#breadcrumbs li.current' do
            expect(page).to have_content "##{pending.id}"
        end
        within '.row .fourcol:first-child .widget-content ul' do
            expect(find('li:first-child')).to have_content pending.email
            expect(find('li:nth-child(2) span')).to have_content 'Pending'
        end
        within '.row .fourcol:nth-child(2) .widget-content' do
            expect(page).to have_content pending.billing_address.full_name
        end
        within '.row .fourcol.last .widget-content' do
            expect(page).to have_content pending.delivery_address.address
        end
        within '.table-margin tbody' do
            expect(find('tr:nth-child(3) td:last-child')).to have_content pending.delivery.price
        end
        within 'table:not(.table-margin) tbody' do
            expect(find('tr td:first-child')).to have_content pending.transactions.last.transaction_type
            expect(find('tr td:nth-child(4) span')).to have_content 'Pending'
        end
    end

    scenario 'should display a complete order' do
        complete

        visit admin_orders_path
        find('tbody tr td:last-child a:first-child').click
        expect(current_path).to eq admin_order_path(complete)
        within 'h2' do
            expect(page).to have_content "Order ##{complete.id}"
        end
        within '#breadcrumbs li.current' do
            expect(page).to have_content "##{complete.id}"
        end
        within '.row .fourcol:first-child .widget-content ul' do
            expect(find('li:first-child')).to have_content complete.email
            expect(find('li:nth-child(2) span')).to have_content 'Dispatched'
        end
        within '.row .fourcol:nth-child(2) .widget-content' do
            expect(page).to have_content complete.billing_address.full_name
        end
        within '.row .fourcol.last .widget-content' do
            expect(page).to have_content complete.delivery_address.address
        end
        within '.table-margin tbody' do
            expect(find('tr:nth-child(3) td:last-child')).to have_content complete.delivery.price
        end
        within 'table:not(.table-margin) tbody' do
            expect(find('tr td:first-child')).to have_content complete.transactions.last.transaction_type
            expect(find('tr td:nth-child(4) span')).to have_content 'Completed'
            expect(find('tr td:last-child')).to have_selector('a', count: 0)
        end
    end

    scenario 'should update the dispatch details for an order', js: true do
        build_dispatch.save(validate: false)
        
        visit admin_orders_path
        find('tbody tr:first-child td:last-child a.edit_order_attributes').click
        sleep 1

        within '.modal#order-form' do
            expect(find('.modal-header h3')).to have_content "Dispatch Order ##{build_dispatch.id}"
            page.execute_script("$('#order_shipping_date').val('14/02/2015')")
            fill_in('order_actual_shipping_cost', with: '1.24')
            click_button 'Submit'
        end
        sleep 1

        expect(current_path).to eq admin_orders_path
        build_dispatch.reload
        within '.alert.alert-success' do
            expect(page).to have_content "Successfully updated dispatch details for Order ##{build_dispatch.id} to #{build_dispatch.shipping_date.strftime("#{build_dispatch.shipping_date.day.ordinalize} %b %Y")}."
        end
        expect(build_dispatch.actual_shipping_cost).to eq BigDecimal.new('1.24')
        expect(build_dispatch.shipping_date.to_s).to eq "2015-02-14 00:00:00 UTC"
    end
end