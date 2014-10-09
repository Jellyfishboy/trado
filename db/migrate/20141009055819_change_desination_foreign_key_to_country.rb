class ChangeDesinationForeignKeyToCountry < ActiveRecord::Migration
  def change
    rename_column :destinations, :zone_id, :country_id
  end
end
