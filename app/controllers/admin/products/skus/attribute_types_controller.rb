class Admin::Products::Skus::AttributeTypesController < ApplicationController

  before_filter :set_attribute_type, only: [:edit, :update, :destroy]
  before_filter :authenticate_user!
  layout 'admin'

  def index
    @attribute_types = AttributeType.all

    respond_to do |format|
      format.html
      format.json { render json: @attribute_types }
    end
  end

  def new
    @attribute_type = AttributeType.new

    respond_to do |format|
      format.html
      format.json { render json: @attribute_type }
    end
  end

  def edit
  end

  def create
    @attribute_type = AttributeType.new(params[:attribute_type])

    respond_to do |format|
      if @attribute_type.save
        flash_message :success, 'Attribute type was successfully created.'
        format.html { redirect_to admin_products_skus_attribute_types_url }
        format.json { render json: @attribute_type, status: :created, location: @attribute_type }
      else
        format.html { render action: "new" }
        format.json { render json: @attribute_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def update

    respond_to do |format|
      if @attribute_type.update_attributes(params[:attribute_type])
        flash_message :success, 'Attribute type was successfully updated.'
        format.html { redirect_to admin_products_skus_attribute_types_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @attribute_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @result = Store::last_record(@attribute_type, AttributeType.all.count)

    respond_to do |format|
      flash_message @result[0], @result[1]
      format.html { redirect_to admin_products_skus_attribute_types_url }
      format.json { head :no_content }
    end
  end

  private

    def set_attribute_type
      @attribute_type = AttributeType.find(params[:id])
    end
end
