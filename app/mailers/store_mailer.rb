class StoreMailer < ActionMailer::Base

    # Deliver a contact email to the administrator
    # These emails are created by users visiting the site who have questions for the store owner
    #
    # @param param [Hash]
    def contact params
        @name = params[:name]
        @email = params[:email]
        @website = params[:website]
        @message = params[:message]

        mail(
            from: "#{@name} <#{@email}>",
            to: Store::settings.email, 
            subject: "New contact message from #{@name}",
            template_path: 'mailer/store',
            template_name: 'contact'
        )
    end
end