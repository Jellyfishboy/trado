class NotificationsController < ApplicationController

    skip_before_filter :authenticate_user!

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