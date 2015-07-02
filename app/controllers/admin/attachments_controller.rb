class Admin::AttachmentsController < ApplicationController
  before_action :set_product
  before_action :set_attachment, except: [:new, :create]
  before_action :authenticate_user!

  def show
    render json: { modal: render_to_string(partial: 'admin/products/attachments/preview') }, status: 200
  end

  def new 
    @attachment = @product.attachments.build
    render partial: 'admin/products/attachments/new_edit', format: [:js]
  end

  def create
    @attachment = @product.attachments.build(params[:attachment])
    respond_to do |format|
      if @attachment.save
        format.js { render partial: 'admin/products/attachments/create', format: [:js] }
      else
        format.json { render json: { errors: @attachment.errors.full_messages }, status: 422 }
      end
    end
  end

  def edit
    render partial: 'admin/products/attachments/new_edit', format: [:js]
  end

  def update
    respond_to do |format|
      if @attachment.update(params[:attachment])
        format.js { render partial: 'admin/products/attachments/update', format: [:js] }
      else
        format.json { render json: { errors: @attachment.errors.full_messages }, status: 422 }
      end
    end
  end

  def destroy
    attachment_id = @attachment.id
    @attachment.destroy
    if @product.attachments.empty?
        render json: { last_record: true, html: '<div class="helper-notification"><p>You do not have any images for this product.</p><i class="icon-images"></i></div>' }
    else
        render json: { last_record: false, attachment_id: attachment_id }
    end
  end

  private

    def set_product
      @product = Product.find(params[:product_id])
    end

    def set_attachment
      @attachment = Attachment.find(params[:id])
    end
end
