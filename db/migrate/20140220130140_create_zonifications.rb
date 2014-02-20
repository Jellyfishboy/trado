class CreateZonifications < ActiveRecord::Migration
  def change
    create_table :zonifications do |t|
      t.integer :country_id
      t.integer :zone_id

      t.timestamps
    end
  end
end
