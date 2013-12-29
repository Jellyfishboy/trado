class RemovePayTypeReferences < ActiveRecord::Migration
  def change
    remove_column :orders, :pay_type_id
  end
end
