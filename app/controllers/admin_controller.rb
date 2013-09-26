class AdminController < ActionController::Base
    before_filter :authenticate_user!
    layout 'admin'

    def dashboard 

    end
end