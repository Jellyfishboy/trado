class AddDescriptionColumnToShipping < ActiveRecord::Migration
  def change
    add_column :shippings, :description, :text
  end
end
