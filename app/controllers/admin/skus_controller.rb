class Admin::SkusController < ApplicationController

  # POST /skus
  # POST /skus.json
  def create
    @sku = Sku.new(params[:sku])

    respond_to do |format|
      if @sku.save
        format.html { redirect_to @sku, notice: 'Sku was successfully created.' }
        format.json { render json: @sku, status: :created, location: @sku }
      else
        format.html { render action: "new" }
        format.json { render json: @sku.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /skus/1
  # PUT /skus/1.json
  def update
    @sku = Sku.find(params[:id])

    respond_to do |format|
      if @sku.update_attributes(params[:sku])
        format.html { redirect_to @sku, notice: 'Sku was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sku.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /skus/1
  # DELETE /skus/1.json
  def destroy
    @sku = Sku.find(params[:id])
    @sku.destroy

    respond_to do |format|
      format.html { redirect_to skus_url }
      format.json { head :no_content }
    end
  end
end
