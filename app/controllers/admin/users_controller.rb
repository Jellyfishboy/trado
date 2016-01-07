class Admin::UsersController < ApplicationController
  before_action :authenticate_user!, :except => :new
  load_and_authorize_resource
  layout 'admin'

    def edit
        set_user
        @attachment = @user.build_attachment unless @user.attachment
    end

    def update
        set_user
        respond_to do |format|
            if @user.update(params[:user])
                flash_message :success, 'Profile was successfully updated.'
                format.html { redirect_to admin_root_url }
                format.json { head :no_content }
            else
                flash_message :error, 'There was an error when attempting to update your profile details.'
                format.html { render action: "edit" }
            end
        end
    end

    private

    def set_user
        @user = current_user
    end
end