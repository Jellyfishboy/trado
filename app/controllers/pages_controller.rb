class PagesController < ApplicationController

    skip_before_action :authenticate_user!
    before_action :set_page, except: :send_contact_message

    def standard
        render theme_presenter.page_template_path('pages/standard'), format: [:html]
    end

    def contact
        @contact_message = ContactMessage.new

        render theme_presenter.page_template_path('pages/contact'), format: [:html]
    end

    def send_contact_message
        @contact_message = ContactMessage.new(params[:contact_message])

        respond_to do |format|
            if @contact_message.valid?
                format.js { render partial: theme_presenter.page_template_path('pages/contact_message/success'), format: [:js], status: 200 }
                StoreMailer.contact_message(params[:contact_message]).deliver
            else
                format.json { render json: { errors: @contact_message.errors.to_json(root: true) }, status: 422 }
            end
        end
    end

    private

    def set_page
        @page = Page.find(params[:id])
    end
end