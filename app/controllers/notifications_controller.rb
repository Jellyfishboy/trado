class NotificationsController < ApplicationController

    def create
    @notification = Notification.new(params[:notification])
    @notification.notifiable_id = params[:sku_id]
    respond_to do |format|
      if @notification.save
        @sku = Sku.find(params[:sku_id])
        binding.pry
        Notifier.sku_stock_confirmation(@sku, params[:notification][:email])
        format.js { render :partial => 'products/successful_notification', :format => [:js] }
      else
        format.json { render :json => { :errors => @notification.errors.to_json(root: true)}, :status => 422 }
      end
    end
  end

end