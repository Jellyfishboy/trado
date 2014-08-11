class AddZoneIdToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :zone_id, :integer
    drop_table :zonifications
  end
end
