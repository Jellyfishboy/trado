class UpdateCartDeliveriesJob < ActiveJob::Base
    queue_as :carts

    def perform cart
        
    end
end
