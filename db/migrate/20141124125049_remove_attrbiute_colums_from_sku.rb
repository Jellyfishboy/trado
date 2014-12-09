class RemoveAttrbiuteColumsFromSku < ActiveRecord::Migration
  def change
    remove_column :skus, :attribute_value
    remove_column :skus, :attribute_type_id
  end
end
