class RemoveAvailableAttributeFromCountries < ActiveRecord::Migration
  def up
    remove_column :countries, :available
  end

  def down
    add_column :countries, :available, :boolean
  end
end
