class CreateDestinations < ActiveRecord::Migration
  def change
    create_table :destinations do |t|
      t.integer :shipping_id
      t.integer :country_id

      t.timestamps
    end
  end
end
