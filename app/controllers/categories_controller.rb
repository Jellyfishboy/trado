class CategoriesController < ApplicationController
    skip_before_action :authenticate_user!

    def show
        set_category
        render theme_presenter.page_template_path('categories/show'), format: [:html], layout: theme_presenter.layout_template_path
    end

    private

    def set_category
      @category ||= Category.includes(:products, :skus, :attachments).where(products: { status: 1, active: true } ).find(params[:id])
    end
end