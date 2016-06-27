class P::PagesController < ApplicationController
    skip_before_action :authenticate_user!

    def show
        set_page
        raise ActiveRecord::RecordNotFound if @page.nil?
        if @page.contact?
            @contact_message = ContactMessage.new 
            render theme_presenter.page_template_path('pages/contact'), format: [:html], layout: theme_presenter.layout_template_path
        else
            render theme_presenter.page_template_path('pages/standard'), format: [:html], layout: theme_presenter.layout_template_path
        end
    end

    def send_contact_message
        new_contact_message
        if @contact_message.valid?
            StoreMailer.contact_message(params[:contact_message]).deliver_later
            render json: {  }, status: 200
        else
            render json: { errors: @contact_message.errors.full_messages }, status: 422
        end
    end

    private

    def set_page
        @page ||= Page.find_by_slug(params[:slug])
    end

    def new_contact_message
        @contact_message = ContactMessage.new(params[:contact_message])
    end
end