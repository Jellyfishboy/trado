class Admin::CategoriesController < ApplicationController
  
  before_action :set_category, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  layout 'admin'

  def index
    @categories = Category.all

    respond_to do |format|
      format.html
      format.json { render json: @categories }
    end
  end

  def new
    @category = Category.new

    respond_to do |format|
      format.html
      format.json { render json: @category }
    end
  end

  def edit
  end

  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        flash_message :success, 'Category was successfully created.'
        format.html { redirect_to admin_categories_url }
        format.json { render json: @category, status: :created, location: @category }
      else
        format.html { render action: "new" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def update

    respond_to do |format|
      if @category.update(params[:category])
        flash_message :success, 'Category was successfully updated.'
        format.html { redirect_to admin_categories_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @result = Store::last_record(@category, Category.all.count)

    respond_to do |format|
      flash_message @result[0], @result[1]
      format.html { redirect_to admin_categories_url }
      format.json { head :no_content }
    end
  end

  private

    def set_category
      @category = Category.find(params[:id])
    end

end
