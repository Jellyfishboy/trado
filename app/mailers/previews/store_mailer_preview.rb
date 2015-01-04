class StoreMailerPreview < ActionMailer::Preview

    def contact_message
        params = 
        {
            :name =>  'Tom Dallimore',
            :email => 'me@tomdallimore.com',
            :website => 'http://www.tomdallimore.com',
            :message => 'Hi, this is a message'
        }
        StoreMailer.contact_message(params)
    end
end