class ErrorsController < ApplicationController
    skip_before_action :authenticate_user!
    
    def show
        render theme_presenter.page_template_path("errors/#{status_code.to_s}"), format: [:html], layout: theme_presenter.layout_template_path, status: status_code
    end

    private

    def status_code
        params[:code] || 500
    end
end