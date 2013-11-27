class Admin::TagsController < ApplicationController
  layout 'admin'

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag = Tag.find(params[:id])
    respond_to do |format|
      if @tag.destroy
        flash[:success] = "Tag was successfully deleted."
        format.js { render :partial => "tags/destroy", :format => [:js] }
      else
        flash[:error] = "Tag failed to be removed from the database."
      end
      format.html
    end
  end
end
