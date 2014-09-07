class AddStatusAttributeToProducts < ActiveRecord::Migration
  def change
    add_column :products, :status, :integer
  end
end
