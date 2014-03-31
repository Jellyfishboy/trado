class CreateStoreSettings < ActiveRecord::Migration
  def change
    create_table :store_settings do |t|
      t.string :name
      t.string :email
      t.string :currency
      t.string :tax_name
      t.integer :user_id

      t.timestamps
    end
  end
end
