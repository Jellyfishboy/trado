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

    def pending_delivery_time order
        "<i class='icon-clock label label-blue label-small' data-placement='bottom' data-toggle='tooltip' data-original-title='Delivery Date Set'></i>".html_safe if order.has_pending_delivery_datetime?
    end
end