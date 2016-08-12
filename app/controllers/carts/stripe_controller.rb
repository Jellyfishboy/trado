class StripeController < ApplicationController
    skip_before_action :authenticate_user!
    include CartBuilder

    def confirm
        
    end
end