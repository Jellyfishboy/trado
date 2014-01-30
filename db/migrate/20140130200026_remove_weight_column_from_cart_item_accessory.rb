class RemoveWeightColumnFromCartItemAccessory < ActiveRecord::Migration
  def change
    remove_column :cart_item_accessories, :weight
  end
end
