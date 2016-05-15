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
        if @user.update(params[:user])
            flash_message :success, 'Profile was successfully updated.'
            redirect_to admin_root_url
        else
            flash_message :error, 'There was an error when attempting to update your profile details.'
            render :edit
        end
    end

    private

    def set_user
        @user = current_user
    end
end