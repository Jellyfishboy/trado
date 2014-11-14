class Admin::AdminController < ApplicationController
    before_action :set_setting
    before_action :authenticate_user!
    layout 'admin'

    def dashboard
        @dashboard = Order.dashboard_data
    end

    def settings
        @settings.build_attachment unless @settings.attachment
    end

    def update
    
        respond_to do |format|
          if @settings.update(params[:store_setting])
            flash_message :success, 'Store settings were successfully updated.'
            format.html { redirect_to admin_root_path }
          else
            format.html { render action: "settings" } 
          end
        end
    end

    private

    def set_setting
        @settings = Store::settings
    end
end