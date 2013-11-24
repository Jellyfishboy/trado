class ModifyOrderColumns < ActiveRecord::Migration
  def change
    rename_column :orders, :first_name, :billing_first_name
    rename_column :orders, :last_name, :billing_last_name
    add_column :orders, :delivery_first_name, :string
    add_column :orders, :delivery_last_name, :string
    add_column :orders, :delivery_company, :string
  end
end
