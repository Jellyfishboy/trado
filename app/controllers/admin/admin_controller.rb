class Admin::AdminController < ApplicationController
    
    before_filter :authenticate_user!
    layout 'admin'

    def dashboard 

    end

    def settings
        @settings = current_user.store_setting
    end

    def update
        @settings = current_user.store_setting
        
        respond_to do |format|
          if @settings.update_attributes(params[:store_setting])
            Store::reset_settings
            format.html { redirect_to admin_root_path, notice: 'Store settings were successfully updated.' }
            format.json { head :no_content }
          else
            format.html { render action: "settings" }
            format.json { render json: @settings.errors, status: :unprocessable_entity }
          end
        end
    end
    
end