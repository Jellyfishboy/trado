class CategoriesController < ApplicationController

    skip_before_action :authenticate_user!
    

    def show
      @category = Category.includes(:products).active.where(products: { status: 1 } ).find(params[:id])
      respond_to do |format|
        format.html
        format.json { render json: @category }
      end
    end
end