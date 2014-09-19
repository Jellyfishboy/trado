class StoreMailerPreview < BasePreview

    def contact
        params = 
        {
            :name =>  'Tom Dallimore',
            :email => 'me@tomdallimore.com',
            :website => 'http://www.tomdallimore.com',
            :message => 'Hi, this is a message'
        }
        StoreMailer.contact(params)
    end
end