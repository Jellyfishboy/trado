class RemoveWeightIdColumnFromShipping < ActiveRecord::Migration
  def change
    remove_column :shippings, :weight_id
  end
end
