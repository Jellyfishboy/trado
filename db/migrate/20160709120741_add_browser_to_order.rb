class AddBrowserToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :browser, :string
  end
end
