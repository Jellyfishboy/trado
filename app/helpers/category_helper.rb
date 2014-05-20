module CategoryHelper

    def price_range product
        min = product.skus.minimum(:price)
        max = product.skus.maximum(:price)
        min == max ? "#{format_currency(max)}".html_safe : "#{format_currency(min)} - #{format_currency(max)}".html_safe
    end
end