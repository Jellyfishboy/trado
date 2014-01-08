class Admin::AttributeValuesController < ApplicationController

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
