class Admin::AttachmentsController < Admin::AdminBaseController
  before_action :authenticate_user!

  def show
    set_product
    set_attachment
    render json: { modal: render_to_string(partial: 'admin/products/attachments/preview') }, status: 200
  end

  def new 
    set_product
    new_attachment
    render json: { modal: render_to_string(partial: 'admin/products/attachments/modal', locals: { url: admin_product_attachments_path, method: 'POST' }) }, status: 200
  end

  def create
    set_product
    @attachment = @product.attachments.build(params[:attachment])
    if @attachment.save
      set_attachments
      render json: { images: render_to_string(partial: 'admin/products/attachments/multiple', locals: { attachments: @attachments }) }, status: 201
    else
      render json: { errors: @attachment.errors.full_messages }, status: 422
    end
  end

  def edit
    set_product
    set_attachment
    render json: { modal: render_to_string(partial: 'admin/products/attachments/modal', locals: { url: admin_product_attachment_path, method: 'PATCH' }) }, status: 200
  end

  def update
    set_product
    set_attachment
    if @attachment.update(params[:attachment])
      set_attachments
      render json: { images: render_to_string(partial: 'admin/products/attachments/multiple', locals: { attachments: @attachments }) }, status: 200
    else
      render json: { errors: @attachment.errors.full_messages }, status: 422
    end
  end

  def destroy
    set_product
    set_attachment
    attachment_id = @attachment.id
    @attachment.destroy
    if @product.attachments.empty?
      render json: { last_record: true, html: "<div class='helper-notification'><p>#{t('controllers.admin.attachments.destroy.limit_reached')}</p><i class='icon-images'></i></div>" }, status: 200
    else
      render json: { last_record: false, attachment_id: attachment_id }, status: 200
    end
  end

  private

  def new_attachment
    @attachment = @product.attachments.build
  end

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_attachment
    @attachment = Attachment.find(params[:id])
  end

  def set_attachments
    @attachments = @product.attachments
  end
end
