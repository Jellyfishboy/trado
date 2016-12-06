class CreateAddressCountries < ActiveRecord::Migration
  def change
    create_table :address_countries do |t|
      t.integer :address_id
      t.integer :country_id

      t.timestamps null: false
    end
  end
end
