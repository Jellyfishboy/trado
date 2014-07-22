class Admin::Products::TagsController < ApplicationController
  
  before_action :authenticate_user!

  # A JSON index of all the tags in the database for the tagsinput typeahead functionality
  #
  # @return [JSON object]
  def index 
    @tags = Tag.all.map(&:name)
    render json: @tags
  end
end
