class CategoriesController < ApplicationController

    skip_before_action :authenticate_user!
    

    def show
      @category = Category.includes(:products).active.where(products: { status: 1 } ).find(params[:id])
      
      render theme_presenter.page_template_path('categories/show'), format: [:html]
    end
end