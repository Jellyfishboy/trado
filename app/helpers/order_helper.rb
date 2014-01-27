module OrderHelper

    def shipping_status status
      if status == "Pending"
        "<span class='label label-warning'>#{status}</span>".html_safe
      elsif status == "Dispatched"
        "<span class='label label-success'>#{status}</span>".html_safe
      end
    end
    
    def payment_status status
      unless status == "Completed"
        "<span class='label label-warning'>#{status}</span>".html_safe
      else
        "<span class='label label-success'>#{status}</span>".html_safe
      end
    end
    
end