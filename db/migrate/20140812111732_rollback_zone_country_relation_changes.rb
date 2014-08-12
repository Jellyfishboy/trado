class RollbackZoneCountryRelationChanges < ActiveRecord::Migration
  def change
    remove_column :countries, :zone_id
    create_table "zonifications", force: true do |t|
        t.integer  "country_id"
        t.integer  "zone_id"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
    end
  end
end
