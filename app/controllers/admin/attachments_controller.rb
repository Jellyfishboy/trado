class Admin::AttachmentsController < ApplicationController
  
  before_filter :authenticate_user!

  def destroy
    @attachment = Attachment.find(params[:id])
    respond_to do |format|
      if @attachment.attachable.attachments.count > 1
        @attachment.destroy
        format.js { render :partial => "admin/products/attachments/destroy", :format => [:js] }
      else
        format.js { render :partial => "admin/products/attachments/failed_destroy", :format => [:js] }
      end
    end
  end
end
