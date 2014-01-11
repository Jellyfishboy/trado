class NotificationsController < ApplicationController

    # FIXME: This is very adhoc for the SKU notifications. If other models started using the notifications table, errors would occur due to the absence of the param[:sku_id]
    def create
    @notification = Notification.new(params[:notification])
    
    respond_to do |format|
      if @notification.save
        format.js { render :partial => 'products/successful_notification', :format => [:js] }
      else
        format.json { render :json => { :errors => @notification.errors.to_json(root: true)}, :status => 422 }
      end
    end
  end

end