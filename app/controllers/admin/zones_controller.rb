class Admin::ZonesController < ApplicationController

  before_action :set_zone, only: [:edit, :update, :destroy, :get_associations]
  before_action :get_associations, except: [:index, :destroy, :set_zone]
  before_action :authenticate_user!
  layout "admin"

  def index
    @zones = Zone.includes(:countries).load

    respond_to do |format|
      format.html
      format.json { render json: @zones }
    end
  end


  def new
    @zone = Zone.new

    respond_to do |format|
      format.html 
      format.json { render json: @zone }
    end
  end

  def edit
  end

  def create
    @zone = Zone.new(params[:zone])

    respond_to do |format|
      if @zone.save
        flash_message :success, 'Zone was successfully created.'
        format.html { redirect_to admin_zones_url }
        format.json { render json: @zone, status: :created, location: @zone }
      else
        format.html { render action: "new" }
        format.json { render json: @zone.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @zone.update(params[:zone])
        flash_message :success, 'Zone was successfully updated.'
        format.html { redirect_to admin_zones_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @zone.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @result = Store::last_record(@zone, Zone.all.count)

    respond_to do |format|
      flash_message @result[0], @result[1]
      format.html { redirect_to admin_zones_url }
      format.json { head :no_content }
    end
  end

  private

    def set_zone
      @zone = Zone.find(params[:id])
    end

    def get_associations
      @countries = @zone.nil? ? Country.where(zone_id: nil).load : Country.where("zone_id = #{@zone.id} OR zone_id IS NULL").load
    end
end
