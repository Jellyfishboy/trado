class AddStripeCardTokenToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :stripe_card_token, :string
  end
end
