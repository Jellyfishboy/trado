class DropZonesAndZonificationTable < ActiveRecord::Migration
  def change
    drop_table :zones
    drop_table :zonifications
  end
end
