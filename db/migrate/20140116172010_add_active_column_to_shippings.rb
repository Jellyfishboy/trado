class AddActiveColumnToShippings < ActiveRecord::Migration
  def change
    add_column :shippings, :active, :boolean
  end
end
