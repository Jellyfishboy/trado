class StoreMailer < ActionMailer::Base

    # Deliver a message to the administrator
    # These emails are created by users visiting the site who have questions for the store owner
    #
    # @param param [Hash]
    def contact_message params
        @name = params[:name]
        @email = params[:email]
        @website = params[:website]
        @message = params[:message]

        mail(to: Store.settings.email, 
            from: "#{@name} <#{@email}>",
            subject: "New message from #{@name}"
        ) do |format|
            format.html { render "admin/emails/store/contact_message", layout: "admin/layouts/email" }
            format.text { render "admin/emails/store/contact_message", layout: "admin/layouts/email" }
        end
    end
end