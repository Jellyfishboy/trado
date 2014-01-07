class Admin::AttributeValuesController < ApplicationController

  # POST /attribute_values
  # POST /attribute_values.json
  def create
    @attribute_value = AttributeValue.new(params[:attribute_value])

    respond_to do |format|
      if @attribute_value.save
        format.html { redirect_to @attribute_value, notice: 'Variant value was successfully created.' }
        format.json { render json: @attribute_value, status: :created, location: @attribute_value }
      else
        format.html { render action: "new" }
        format.json { render json: @attribute_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /attribute_values/1
  # PUT /attribute_values/1.json
  def update
    @attribute_value = AttributeValue.find(params[:id])

    respond_to do |format|
      if @attribute_value.update_attributes(params[:attribute_value])
        format.html { redirect_to @attribute_value, notice: 'Variant value was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @attribute_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attribute_values/1
  # DELETE /attribute_values/1.json
  def destroy
    @attribute_value = AttributeValue.find(params[:id])
    @attribute_value.destroy

    respond_to do |format|
      format.html { redirect_to attribute_values_url }
      format.json { head :no_content }
    end
  end
end
