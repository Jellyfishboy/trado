class RemoveShippingIdColumnFromDimensions < ActiveRecord::Migration
  def change
    remove_column :dimensions, :shipping_id
  end
end
