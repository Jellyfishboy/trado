class Admin::VariantValuesController < ApplicationController

  # POST /variant_values
  # POST /variant_values.json
  def create
    @variant_value = VariantValue.new(params[:variant_value])

    respond_to do |format|
      if @variant_value.save
        format.html { redirect_to @variant_value, notice: 'Variant value was successfully created.' }
        format.json { render json: @variant_value, status: :created, location: @variant_value }
      else
        format.html { render action: "new" }
        format.json { render json: @variant_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /variant_values/1
  # PUT /variant_values/1.json
  def update
    @variant_value = VariantValue.find(params[:id])

    respond_to do |format|
      if @variant_value.update_attributes(params[:variant_value])
        format.html { redirect_to @variant_value, notice: 'Variant value was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @variant_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /variant_values/1
  # DELETE /variant_values/1.json
  def destroy
    @variant_value = VariantValue.find(params[:id])
    @variant_value.destroy

    respond_to do |format|
      format.html { redirect_to variant_values_url }
      format.json { head :no_content }
    end
  end
end
