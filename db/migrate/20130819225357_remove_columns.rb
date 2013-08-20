class RemoveColumns < ActiveRecord::Migration
  def change
    remove_column :shippings, :dimension_id
    add_column :dimensions, :shipping_id, :integer
  end
end
