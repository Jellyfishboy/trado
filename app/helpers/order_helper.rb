module OrderHelper

    def status_label record, status
        if record.class == Order
            class_name = record.dispatched? ? 'green' : record.pending? ? 'orange' : 'red'
        elsif record.class == Transaction
            class_name = record.completed? ? 'green' : record.pending? ? 'orange' : 'red'
        end
      "<span class='label label-#{class_name} label-small'>#{status.capitalize}</span>".html_safe
    end
end