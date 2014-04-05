class RemoveAccessoryIdFromSku < ActiveRecord::Migration
  def change
    remove_column :skus, :accessory_id, :integer
  end
end
