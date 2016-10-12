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
            @order.remove_redundant_stripe_cards
            @order.create_stripe_card
            @order.calculate(current_cart, Store.tax_rate)
            redirect_to confirm_order_url(@order)
        else
            flash_message :error, 'An error ocurred with your order. Please try again.'
            render theme_presenter.page_template_path('carts/checkout'), layout: theme_presenter.layout_template_path
        end
    rescue Stripe::InvalidRequestError
        flash_message :error, 'An error ocurred with your order. Please try again.'  
        Rails.logger.error "Stripe: Unable to create card for customer #{@order.email} | #{@order.id}"
        redirect_to checkout_carts_url
    end

    private

    def set_grouped_countries
        @grouped_countries = [Country.popular.map{ |country| [country.name, country.name] }, Country.all.order('name ASC').map{ |country| [country.name, country.name] }] 
    end
end