class AddDescriptionColumnToPayType < ActiveRecord::Migration
  def change
    add_column :pay_types, :description, :text
  end
end
