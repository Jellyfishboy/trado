module HasStripeCustomer
    extend ActiveSupport::Concern

    included do
        after_create :assign_stripe_customer, if: :no_stripe_customer_token?

        def stripe_customer
            Stripe::Customer.retrieve(stripe_customer_token)
        rescue Stripe::InvalidRequestError
            assign_stripe_customer
        end

        def stripe_cards
            stripe_customer.sources.all(:object => "card")['data']
        end

        def default_card
            stripe_customer.sources.retrieve(stripe_customer.default_source)
        end
    end

    def assign_stripe_customer
        customer = Stripe::Customer.create(
            email: email,
            description: billing_address.full_name
        )
        self.update_column(:stripe_customer_token, customer.id)
    end

    def no_stripe_customer_token?
        stripe_customer_token.present? ? false : true
    end
end