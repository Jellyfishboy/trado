require 'spec_helper'

feature 'Order management' do
    
    store_setting
    feature_login_admin

    scenario 'should display an index of orders' do
        order = create(:undispatched_complete_order)
        order_2 = create(:pending_order)

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
        order = create(:pending_order)

        visit admin_orders_path
        find('tbody tr td:first-child a').click
        expect(current_path).to eq admin_order_path(order)
        within 'h2' do
            expect(page).to have_content "Order ##{order.id}"
        end
        within '#breadcrumbs li.current' do
            expect(page).to have_content "Order ##{order.id}"
        end
        within '.row .fourcol:first-child .widget-content ul' do
            expect(find('li:first-child')).to have_content order.email
            expect(find('li:nth-child(3) span')).to have_content 'Pending'
        end
        within '.row .fourcol:nth-child(2) .widget-content' do
            expect(page).to have_content order.bill_address.full_name
        end
        within '.row .fourcol.last .widget-content' do
            expect(page).to have_content order.ship_address.address
        end
        within '.table-margin tbody' do
            expect(find('tr:nth-child(2) td:first-child')).to have_content order.shipping.name
        end
        within 'table:not(.table-margin) tbody' do
            expect(find('tr td:first-child')).to have_content order.transactions.last.transaction_type
            expect(find('tr td:nth-child(4) span')).to have_content 'Pending'
            expect(find('tr td:last-child')).to have_selector('a', count: 1)
        end
    end

    scenario 'should display a complete order' do
        order = create(:complete_order)

        visit admin_orders_path
        find('tbody tr td:first-child a').click
        expect(current_path).to eq admin_order_path(order)
        within 'h2' do
            expect(page).to have_content "Order ##{order.id}"
        end
        within '#breadcrumbs li.current' do
            expect(page).to have_content "Order ##{order.id}"
        end
        within '.row .fourcol:first-child .widget-content ul' do
            expect(find('li:first-child')).to have_content order.email
            expect(find('li:nth-child(3) span')).to have_content 'Dispatched'
        end
        within '.row .fourcol:nth-child(2) .widget-content' do
            expect(page).to have_content order.bill_address.full_name
        end
        within '.row .fourcol.last .widget-content' do
            expect(page).to have_content order.ship_address.address
        end
        within '.table-margin tbody' do
            expect(find('tr:nth-child(2) td:first-child')).to have_content order.shipping.name
        end
        within 'table:not(.table-margin) tbody' do
            expect(find('tr td:first-child')).to have_content order.transactions.last.transaction_type
            expect(find('tr td:nth-child(4) span')).to have_content 'Completed'
            expect(find('tr td:last-child')).to have_selector('a', count: 0)
        end
    end

    scenario 'should update the shipping cost value of an order', js: true do
        order = build(:nil_actual_shipping_order)
        order.save(validate: false)
        
        visit admin_orders_path
        find('tbody tr:first-child td:last-child a.edit_order_attributes').click
        sleep 1

        within '.modal#order-form' do
            fill_in('order_actual_shipping_cost', with: '1.24')
            click_button 'Submit'
        end
        expect(current_path).to eq admin_orders_path
        within '.alert.alert-success' do
            expect(page).to have_content "Successfully updated Order ##{order.id}"
        end
        order.reload
        expect(order.actual_shipping_cost).to eq BigDecimal.new('1.24')
    end


    scenario 'should add the dispatch date to an order, when payment status complete', js: true do
        order = create(:nil_shipping_date_order)

        visit admin_orders_path
        find('tbody tr td:last-child a.order_shipping').click
        sleep 1

        within '.modal#shipping-form' do
            expect(find('.modal-header h3')).to have_content "Dispatch Order ##{order.id}"
            page.execute_script("$('#order_shipping_date').val('14/02/2015')")
            click_button 'Submit'
        end
        sleep 1

        expect(current_path).to eq admin_orders_path
        order.reload
        within '.alert.alert-success' do
            expect(page).to have_content "Successfully updated the dispatch date for Order ##{order.id} to #{order.shipping_date.strftime("#{order.shipping_date.day.ordinalize} %b %Y")}"
        end
        expect(order.shipping_date.to_s).to eq "2015-02-14 00:00:00 UTC"
    end 

    scenario 'should update the payment status of a cheque or bank transfer based order transaction', js: true do
        order = create(:cheque_order)

        visit admin_orders_path
        find('tbody tr td:first-child a').click
        expect(current_path).to eq admin_order_path(order)
        within 'h2' do
            expect(page).to have_content "Order ##{order.id}"
        end
        within '#breadcrumbs li.current' do
            expect(page).to have_content "Order ##{order.id}"
        end
        within 'table:not(.table-margin) tbody' do
            expect(find('tr td:nth-child(2)')).to have_content 'Cheque'
            find('tr td:last-child a.edit_transaction_attributes').click
        end
        sleep 1

        within '.modal#transaction-form' do
            expect(find('.modal-header h3')).to have_content "Edit transaction for Order ##{order.id}"
            find('#transaction_payment_status').set(true)
            click_button 'Submit'
        end
        expect(current_path).to eq admin_order_path(order)
        within '.alert.alert-success' do
            expect(page).to have_content "Successfully updated transaction for Order ##{order.id}"
        end
        order.reload
        expect(order.transactions.first.payment_status).to eq 'Completed'
    end

end