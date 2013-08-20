class DimensionsController < ApplicationController
  layout 'admin'
  # GET /dimensions
  # GET /dimensions.json
  def index
    @dimensions = Dimension.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @dimensions }
    end
  end

  # GET /dimensions/1
  # GET /dimensions/1.json
  def show
    @dimension = Dimension.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dimension }
    end
  end

  # GET /dimensions/new
  # GET /dimensions/new.json
  def new
    @dimension = Dimension.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @dimension }
    end
  end

  # GET /dimensions/1/edit
  def edit
    @dimension = Dimension.find(params[:id])
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

  # PUT /dimensions/1
  # PUT /dimensions/1.json
  def update
    @dimension = Dimension.find(params[:id])

    respond_to do |format|
      if @dimension.update_attributes(params[:dimension])
        format.html { redirect_to @dimension, notice: 'Dimension was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dimension.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dimensions/1
  # DELETE /dimensions/1.json
  def destroy
    @dimension = Dimension.find(params[:id])
    @dimension.destroy

    respond_to do |format|
      format.html { redirect_to dimensions_url }
      format.json { head :no_content }
    end
  end
end
