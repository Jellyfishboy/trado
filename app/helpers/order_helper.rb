require 'modulatron_4000'

module OrderHelper

    def status_label record, status
        if record.class == Order
            class_name = record.dispatched? ? 'green' : record.pending? ? 'orange' : 'red'
        elsif record.class == Transaction
            class_name = record.completed? ? 'green' : record.pending? ? 'orange' : 'red'
        end
      "<span class='label label-#{class_name} label-small'>#{status.capitalize}</span>".html_safe
    end

    def order_filter_classes order
        return order.dispatched? ? "order-dispatched" : "order-pending"
    end

    def checkout_pay_provider_path
        Modulatron4000.paypal? ? paypal_confirm_carts_path : Modulatron4000.stripe? ? stripe_confirm_carts_path : ""
    end
    def pending_delivery_time order
        "<i class='icon-clock label label-blue label-small' data-placement='bottom' data-toggle='tooltip' data-original-title='Delivery Date Set'></i>".html_safe if order.has_pending_delivery_datetime?
    end

    def delivery_filter_select
        [
            ["Show All", "all"],
            ["Dispatched", 1],
            ["Pending", 0]
        ]
    end 

    def payment_filter_select
        [
            ["Show All", "all"],
            ["Paypal", 0],
            ["Stripe", 1]
        ]
    end
end