module OrderHelper

    def shipping_status status
      if status == "Pending"
        "<span class='label label-orange label-small'>#{status}</span>".html_safe
      elsif status == "Dispatched"
        "<span class='label label-green label-small'>#{status}</span>".html_safe
      end
    end
    
    def payment_status status
      if status == "Completed"
        "<span class='label label-green label-small'>#{status}</span>".html_safe
      elsif status == "Pending"
        "<span class='label label-orange label-small'>#{status}</span>".html_safe
      else
        "<span class='label label-red label-small'>#{status}</span>".html_safe
      end
    end
    
end