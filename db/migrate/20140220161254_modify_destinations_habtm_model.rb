class ModifyDestinationsHabtmModel < ActiveRecord::Migration
  def change
    rename_column :destinations, :country_id, :zone_id
  end
end
