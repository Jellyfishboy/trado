class Admin::DimensionsController < ApplicationController
  layout 'admin'
  
  # DELETE /dimensions/1
  # DELETE /dimensions/1.json
  def destroy
    @dimension = Dimension.find(params[:id])
    respond_to do |format|
      if @dimension.destroy
        flash[:success] = "Dimension was successfully deleted."
        format.js { render :partial => "admin/dimensions/destroy", :format => [:js] }
      else
        flash[:error] = "Dimension failed to be removed from the database."
      end
      format.html 
    end
  end
end
