class Admin::AdminController < ApplicationController
    
    before_filter :set_setting
    before_filter :authenticate_user!
    layout 'admin'

    def settings
        @settings.build_attachment unless @settings.attachment
    end

    def update
    
        respond_to do |format|
          if @settings.update_attributes(params[:store_setting])
            Store::reset_settings
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