class ChangeForeignKeyInNotifications < ActiveRecord::Migration
  def change
    rename_column :notifications, :dimension_id, :notifiable_id
  end
end
