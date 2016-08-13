module HasStripeCustomer
    extend ActiveSupport::Concern

    included do
        after_create :assign_stripe_customer

        def stripe_customer
            Stripe::Customer.retrieve(stripe_customer_token)
        end
    end

    def assign_stripe_customer
        customer = Stripe::Customer.create(
            email: email,
            description: billing_address.full_name
        )
        self.update_column(:stripe_customer_token, customer.id)
    end
end