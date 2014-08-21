class ContactsController < ApplicationController

    skip_before_action :authenticate_user!

    def new
        @contact = Contact.new

        render 'store/contact'
    end

    def create
        @contact = Contact.new(params[:contact])

        respond_to do |format|
            if @contact.valid?
                format.js { render partial: 'store/contact/success', format: [:js], status: 200 }
                StoreMailer.contact(params[:contact]).deliver
            else
                format.json { render json: { errors: @contact.errors.to_json(root: true) }, status: 422 }
            end
        end
    end
end