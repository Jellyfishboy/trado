class DimensionsController < ApplicationController
  layout 'admin'
  # GET /dimensions/new
  # GET /dimensions/new.json
  def new
    @dimension = Dimension.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @dimension }
    end
  end

  # POST /dimensions
  # POST /dimensions.json
  def create
    @dimension = Dimension.new(params[:dimension])

    respond_to do |format|
      if @dimension.save
        format.html { redirect_to @dimension, notice: 'Dimension was successfully created.' }
        format.json { render json: @dimension, status: :created, location: @dimension }
      else
        format.html { render action: "new" }
        format.json { render json: @dimension.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dimensions/1
  # DELETE /dimensions/1.json
  def destroy
    @dimension = Dimension.find(params[:id])
    respond_to do |format|
      if @dimension.destroy
        flash[:success] = "Dimension was successfully deleted."
        format.js { render :partial => "dimensions/destroy", :format => [:js] }
      else
        flash[:error] = "Dimension failed to be removed from the database."
      end
      format.html 
    end
  end
end
