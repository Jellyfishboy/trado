class Admin::UsersController < ApplicationController

  before_action :set_user
  before_action :authenticate_user!, :except => :new
  load_and_authorize_resource
  layout 'admin'

    def edit
        @attachment = @user.build_attachment unless @user.attachment
        respond_to do |format|
            format.html
            format.json { render :json => @user }   
        end
    end

    def update

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