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

        def create_stripe_card
            stripe_customer.sources.create(source: stripe_card_token)
        end

        def remove_redundant_stripe_cards
            stripe_cards.each do |card|
                stripe_customer.sources.retrieve(card.id).delete()
            end
        end
    end

    def assign_stripe_customer
        customer = Stripe::Customer.create(
            email: email,
            description: billing_address.full_name,
            shipping: {
                name: delivery_address.full_name,
                phone: delivery_address.telephone,
                address: {
                    line1: delivery_address.address,
                    city: delivery_address.city,
                    country: delivery_address.country.name,
                    postal_code: delivery_address.postcode,
                    state: delivery_address.county
                }
            }
        )
        self.update_column(:stripe_customer_token, customer.id)
    end

    def no_stripe_customer_token?
        stripe_customer_token.present? ? false : true
    end
end