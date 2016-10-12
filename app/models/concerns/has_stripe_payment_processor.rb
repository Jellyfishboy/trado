module HasStripePaymentProcessor
    extend ActiveSupport::Concern

    included do
        after_commit :create_stripe_customer,                           if: :no_stripe_customer_token?
        after_commit :update_stripe_customer,                           if: :email_or_billing_name_changed?

        def stripe_customer
            Stripe::Customer.retrieve(stripe_customer_token)
        rescue Stripe::InvalidRequestError
            create_stripe_customer
        end

        def stripe_cards
            stripe_customer.sources.all(:object => "card")['data']
        end

        def default_card
            stripe_customer.sources.retrieve(stripe_customer.default_source)
        end

        def create_stripe_card
            stripe_customer.sources.create(source: stripe_card_token)
        end

        def remove_redundant_stripe_cards
            stripe_cards.each do |card|
                stripe_customer.sources.retrieve(card.id).delete()
            end
        end
    end

    def create_stripe_customer
        customer = Stripe::Customer.create(
            email: email,
            description: billing_address.full_name
        )
        self.update_column(:stripe_customer_token, customer.id)
    end

    def update_stripe_customer
        customer = stripe_customer
        customer.email = email
        customer.description = billing_address.full_name
        customer.save
    end

    def no_stripe_customer_token?
        stripe_customer_token.present? ? false : true
    end

    def email_or_billing_name_changed?
        email_changed? || billing_address.first_name_changed? || billing_address.last_name_changed?
    end
end