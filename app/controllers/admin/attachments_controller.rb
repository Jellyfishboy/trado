class Admin::AttachmentsController < ApplicationController
  
  before_action :authenticate_user!

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
