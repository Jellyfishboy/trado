class Admin::Shippings::TiersController < ApplicationController

  before_filter :set_tier, only: [:edit, :update, :destroy]
  before_filter :authenticate_user!, :active_shippings, only: [:new, :edit, :update]
  layout "admin"

  def index
    @tiers = Tier.includes(:shippings).all

    respond_to do |format|
      format.html
      format.json { render json: @tiers }
    end
  end

  def new
    @tier = Tier.new

    respond_to do |format|
      format.html
      format.json { render json: @tier }
    end
  end

  def edit
  end

  def create
    @tier = Tier.new(params[:tier])

    respond_to do |format|
      if @tier.save
        flash_message :success, 'Tier was successfully created.'
        flash_message :notice, 'Hint: Remember to create a shipping method record so you can start to display shipping results in your order process.' if Shipping.active.all.count < 1
        format.html { redirect_to admin_shippings_tiers_url }
        format.json { render json: @tier, status: :created, location: @tier }
      else
        format.html { render action: "new" }
        format.json { render json: @tier.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @tier.update_attributes(params[:tier])
        flash_message :success, 'Tier was successfully updated.'
        format.html { redirect_to admin_shippings_tiers_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tier.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @result = Store::last_record(@tier, Tier.all.count)

    respond_to do |format|
      flash_message @result[0], @result[1]
      format.html { redirect_to admin_shippings_tiers_url }
      format.json { head :no_content }
    end
  end

  private

    # Retrieves an instantiates an array of active shippings
    #
    # @return [Array] active shippings
    def active_shippings
      @shippings = Shipping.active.all
    end

    def set_tier
      @tier = Tier.find(params[:id])
    end
end
