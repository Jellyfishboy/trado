class ChangeProductIdColumnInAccessorisation < ActiveRecord::Migration
  def change
    rename_column :accessorisations, :accessory_id, :product_option_id
  end
end
