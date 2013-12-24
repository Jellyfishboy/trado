class DropCategorisationsTable < ActiveRecord::Migration
  def change
    drop_table :categorisations
    drop_table :payments
    add_column :products, :category_id, :integer
    add_column :orders, :pay_type_id, :integer
  end
end
