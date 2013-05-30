class AddShipDateToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :ship_date, :datetime
  end
end
