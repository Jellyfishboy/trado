class AddStripeCustomerTokenToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :stripe_customer_token, :string
  end
end
