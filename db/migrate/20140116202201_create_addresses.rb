class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :first_name
      t.string :last_name
      t.string :company
      t.string :address
      t.string :city
      t.string :county
      t.string :postcode
      t.string :country
      t.integer :telephone
      t.boolean :active
      t.boolean :default

      t.timestamps
    end
  end
end
