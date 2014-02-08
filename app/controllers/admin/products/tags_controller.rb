class Admin::Products::TagsController < ApplicationController
  layout 'admin'

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag = Tag.find(params[:id])
    respond_to do |format|
      if @tag.destroy
        format.js { render :partial => "admin/products/tags/destroy", :format => [:js] }
      else
        flash[:error] = "Tag failed to be removed from the database."
      end
      format.html
    end
  end
end
