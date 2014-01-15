class RefactorAccessories < ActiveRecord::Migration
  def change
    drop_table :accessorisations
    remove_column :accessories, :weight
    add_column :skus, :accessory_id, :integer
  end
end
