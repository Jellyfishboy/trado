class Users::RegistrationsController < Devise::RegistrationsController
    before_action :check_permissions, :except => [:new, :create]
    skip_before_action :require_no_authentication

    def check_permissions
        authorize! :create, resource
    end
end