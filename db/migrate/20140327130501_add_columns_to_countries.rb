class AddColumnsToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :iso, :string
    add_column :countries, :available, :boolean, :default => false
  end
end
