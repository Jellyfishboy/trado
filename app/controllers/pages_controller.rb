class PagesController < ApplicationController

    skip_before_action :authenticate_user!

    def standard
        @page = Page.find(params[:id])
    end

    def contact
        @message = Message.new
    end

    def send_message
        @message = Message.new(params[:message])

        respond_to do |format|
            if @message.valid?
                format.js { render partial: 'pages/message/success', format: [:js], status: 200 }
                StoreMailer.message(params[:message]).deliver
            else
                format.json { render json: { errors: @message.errors.to_json(root: true) }, status: 422 }
            end
        end
    end
end