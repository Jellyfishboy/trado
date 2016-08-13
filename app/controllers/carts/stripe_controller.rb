class Carts::StripeController < ApplicationController
    skip_before_action :authenticate_user!
    include CartBuilder

    def confirm
        set_order
        set_cart_totals
        set_cart_session
        set_delivery_services
        set_grouped_countries
        set_browser_data
        @order.attributes = params[:order]
        if @order.save
            create_stripe_card
            @order.calculate(current_cart, Store.tax_rate)
            redirect_to confirm_order_url(@order)
        else
            flash_message :error, 'An error ocurred with your order. Please try again.'
            render theme_presenter.page_template_path('carts/checkout'), layout: theme_presenter.layout_template_path
        end
    # rescue Stripe::ApiConnectionError
    #     flash_message :error, 'An error ocurred with your order. Please try again.'  
    #     Rails.logger.error "Stripe: API is temporarily unavailable."
    #     redirect_to checkout_carts_url
    end

    private

    def set_grouped_countries
        @grouped_countries = [Country.popular.map{ |country| [country.name, country.name] }, Country.all.order('name ASC').map{ |country| [country.name, country.name] }] 
    end

    def create_stripe_card
        @order.stripe_customer.sources.create(source: @order.stripe_card_token)
    end
end