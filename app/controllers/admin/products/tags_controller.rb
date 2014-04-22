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
end
