class CartsController < ApplicationController
    includes CartBuilder
    skip_before_action :authenticate_user!

    def mycart
        render theme_presenter.page_template_path('carts/mycart'), layout: theme_presenter.layout_template_path
    end

    def checkout
        set_order
        set_cart_session
        set_delivery_services
        render theme_presenter.page_template_path('carts/checkout'), layout: theme_presenter.layout_template_path
    end

    def estimate
        @cart = current_cart
        respond_to do |format|
          if @cart.update(params[:cart])
            format.js { render partial: theme_presenter.page_template_path('carts/delivery_service_prices/estimate/success'), format: [:js] }
          else
            format.json { render json: { errors: @cart.errors.to_json(root: true) }, status: 422 }
          end
        end
    end

    def purge_estimate
        @cart = current_cart
        @cart.delivery_id = nil
        @cart.country = nil
        @cart.save(validate: false)
        render partial: theme_presenter.page_template_path('carts/delivery_service_prices/estimate/success'), format: [:js]
    end
end