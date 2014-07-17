class Admin::Zones::CountriesController < ApplicationController

  before_action :set_country, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  layout 'admin'

  def index
    @countries = Country.order(name: :asc).load

    respond_to do |format|
      format.html
      format.json { render json: @countries }
    end
  end

  def new
    @country = Country.new

    respond_to do |format|
      format.html
      format.json { render json: @country }
    end
  end

  def edit
  end

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

  def update

    respond_to do |format|
      if @country.update(params[:country])
        flash_message :success, 'Country was successfully updated.'
        format.html { redirect_to admin_zones_countries_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @country.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @result = Store::last_record(@country, Country.all.count)

    respond_to do |format|
      flash_message @result[0], @result[1]
      format.html { redirect_to admin_zones_countries_url }
      format.json { head :no_content }
    end
  end

  private

    def set_country
      @country = Country.find(params[:id])
    end
end
