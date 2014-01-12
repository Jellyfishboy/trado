class Admin::Products::AttachmentsController < ApplicationController
  layout 'admin'

  # DELETE /attachments/1
  # DELETE /attachments/1.json
  def destroy
    @attachment = Attachment.find(params[:id])
    respond_to do |format|
      if @attachment.destroy
        flash[:success] = "Attachment was successfully deleted."
        format.js { render :partial => "admin/attachments/destroy", :format => [:js] }
      else
        flash[:error] = "Attachment failed to be removed from the database."
      end
      format.html
    end
  end
end
