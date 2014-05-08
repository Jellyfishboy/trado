class Admin::UsersController < ApplicationController

  before_filter :authenticate_user!, :except => :new
  load_and_authorize_resource
  layout 'admin'

    def edit
        @user = current_user
        @attachment = @user.build_attachment unless @user.attachment
        respond_to do |format|
            format.html
            format.json { render :json => @user }   
        end
    end

    def update
        @user = current_user

        respond_to do |format|
          if @user.update_attributes(params[:user])
            format.html { redirect_to admin_root_url, :flash => { :success => 'Profile was successfully updated.' } }
            format.json { head :no_content }
          else
            format.html { render action: "edit", :flash => { :error => "There was an error when attempting to update your login details." } }
          end
        end
    end
    
end