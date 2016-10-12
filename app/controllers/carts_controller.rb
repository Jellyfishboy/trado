class CartsController < ApplicationController
    include CartBuilder
    skip_before_action :authenticate_user!
    before_action :validate_cart_items_presence, only: [:checkout]

    def mycart
        set_cart_totals
        render theme_presenter.page_template_path('carts/mycart'), layout: theme_presenter.layout_template_path
    end

    def checkout
        set_order
        set_grouped_countries
        set_cart_totals
        render theme_presenter.page_template_path('carts/checkout'), layout: theme_presenter.layout_template_path
    end

    private

    def validate_cart_items_presence
        redirect_to root_url if current_cart.cart_items.empty?
    end
end