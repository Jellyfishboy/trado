class PayTypesController < ApplicationController
  # GET /pay_types
  # GET /pay_types.json
  def index
    @pay_types = PayType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pay_types }
    end
  end

  # GET /pay_types/1
  # GET /pay_types/1.json
  def show
    @pay_type = PayType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pay_type }
    end
  end

  # GET /pay_types/new
  # GET /pay_types/new.json
  def new
    @pay_type = PayType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pay_type }
    end
  end

  # GET /pay_types/1/edit
  def edit
    @pay_type = PayType.find(params[:id])
  end

  # POST /pay_types
  # POST /pay_types.json
  def create
    @pay_type = PayType.new(params[:pay_type])

    respond_to do |format|
      if @pay_type.save
        format.html { redirect_to @pay_type, notice: 'Pay type was successfully created.' }
        format.json { render json: @pay_type, status: :created, location: @pay_type }
      else
        format.html { render action: "new" }
        format.json { render json: @pay_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pay_types/1
  # PUT /pay_types/1.json
  def update
    @pay_type = PayType.find(params[:id])

    respond_to do |format|
      if @pay_type.update_attributes(params[:pay_type])
        format.html { redirect_to @pay_type, notice: 'Pay type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pay_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pay_types/1
  # DELETE /pay_types/1.json
  def destroy
    @pay_type = PayType.find(params[:id])
    @pay_type.destroy

    respond_to do |format|
      format.html { redirect_to pay_types_url }
      format.json { head :no_content }
    end
  end
end
