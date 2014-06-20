class ErrorsController < ApplicationController

    skip_before_filter :authenticate_user!
    
    def show
        namespace = params[:controller].split('/').first
        prefix = namespace == 'admin' ? 'admin' : 'application'
        render "#{prefix}/#{status_code.to_s}", :status => status_code
    end

    protected

        def status_code
            params[:code] || 500
        end

end