class AddDefaultValuesForSentAndOutofStock < ActiveRecord::Migration
  def change
    change_column :notifications, :sent, :boolean, :default => false
    change_column :skus, :out_of_stock, :boolean, :default => false
  end
end
