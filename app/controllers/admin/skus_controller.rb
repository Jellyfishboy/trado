class Admin::SkusController < ApplicationController

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
