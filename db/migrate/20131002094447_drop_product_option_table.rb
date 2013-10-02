class DropProductOptionTable < ActiveRecord::Migration
  def change
    drop_table :product_options
  end
end
