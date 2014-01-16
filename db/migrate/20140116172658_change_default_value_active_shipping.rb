class ChangeDefaultValueActiveShipping < ActiveRecord::Migration
  def change
    change_column :shippings, :active, :boolean, :default => true
  end
end
