module CategoryHelper

    def price_range product
        product.skus.count == 1 ? format_currency(product.skus.first.price) : Store::settings.tax_breakdown ? "from #{format_currency(product.skus.minimum(:price))}" : "from #{format_currency(product.skus.minimum(:price))}"
    end
end