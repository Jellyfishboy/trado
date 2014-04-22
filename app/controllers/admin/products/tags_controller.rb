class Admin::Products::TagsController < ApplicationController
  
  before_filter :authenticate_user!

  # A JSON index of all the tags in the database for the tagsinput typeahead functionality
  #
  # @return [JSON object]
  def index 
    @tags = Tag.all.map { |t| t.name }
    
    respond_to do |format|
      format.json { render json: @tags }
    end
  end

  # Destroy a tag record
  #
  # @return [nil]
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
