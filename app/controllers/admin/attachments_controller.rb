class Admin::AttachmentsController < ApplicationController
  
  before_action :authenticate_user!

  def new 
    @product = Product.find(params[:product_id])
    @attachment = @product.attachments.build
    render partial: 'admin/products/attachments/new', format: [:js]
  end

  def create
    @attachment = Attachment.new(params[:attachment])
    respond_to do |format|
      if @attachment.save
        format.js { render :partial => 'admin/products/attachments/success', :format => [:js] }
      else
        format.json { render :json => { :errors => @attachment.errors.full_messages }, :status => 422 }
      end
    end
  end

  def edit

  end

  def update

  end

  def destroy
    @attachment = Attachment.find(params[:id])
    if @attachment.attachable.attachments.count > 1
      @attachment.destroy
      render :partial => "admin/products/attachments/destroy", :format => [:js]
    else
      render :partial => "admin/products/attachments/failed_destroy", :format => [:js]
    end
  end
end
