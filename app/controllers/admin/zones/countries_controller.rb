class Admin::Zones::CountriesController < ApplicationController

  before_filter :authenticate_user!
  layout 'admin'
  # GET /countries
  # GET /countries.json
  def index
    @countries = Country.order('name ASC').all

    respond_to do |format|
      format.html
      format.json { render json: @countries }
    end
  end

  # GET /countries/new
  # GET /countries/new.json
  def new
    @country = Country.new

    respond_to do |format|
      format.html
      format.json { render json: @country }
    end
  end

  # GET /countries/1/edit
  def edit
    @country = Country.find(params[:id])
  end

  # POST /countries
  # POST /countries.json
  def create
    @country = Country.new(params[:country])

    respond_to do |format|
      if @country.save
        flash_message :success, 'Country was successfully created.'
        flash_message :notice, 'Hint: Remember to create a zone record so you can start associating your countries with your shipping methods.' if Zone.all.count < 1
        format.html { redirect_to admin_zones_countries_url }
        format.json { render json: @country, status: :created, location: @country }
      else
        format.html { render action: "new" }
        format.json { render json: @country.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /countries/1
  # PUT /countries/1.json
  def update
    @country = Country.find(params[:id])

    respond_to do |format|
      if @country.update_attributes(params[:country])
        flash_message :success, 'Country was successfully updated.'
        format.html { redirect_to admin_zones_countries_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @country.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /countries/1
  # DELETE /countries/1.json
  def destroy
    @country = Country.find(params[:id])
    @result = Store::last_record(@country, Country.all.count)

    respond_to do |format|
      flash_message @result[0], @result[1]
      format.html { redirect_to admin_zones_countries_url }
      format.json { head :no_content }
    end
  end
end
