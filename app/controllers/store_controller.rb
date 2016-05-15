class StoreController < ApplicationController
    skip_before_action :authenticate_user!

    def home
        set_new_products
        set_featured_products
        render theme_presenter.page_template_path('store/home'), layout: theme_presenter.layout_template_path
    end

    private

    def set_new_products
        @new_products ||= Product.active.published.order(created_at: :desc).first(8)
    end

    def set_featured_products
        @featured_products ||= Product.active.published.where(featured: true).first(4)
    end
end
