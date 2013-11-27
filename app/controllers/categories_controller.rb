class CategoriesController < ApplicationContoller

    # GET /categories/1
    # GET /categories/1.json
    def show
      @category = Category.find(params[:id])
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @category }
      end
    end
end