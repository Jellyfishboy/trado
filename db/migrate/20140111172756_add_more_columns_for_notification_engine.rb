class AddMoreColumnsForNotificationEngine < ActiveRecord::Migration
  def change
    add_column :skus, :out_of_stock, :boolean
    add_column :notifications, :sent, :boolean
    add_column :notifications, :sent_at, :datetime
  end
end
