class DropRailsAdminHistories < ActiveRecord::Migration
  def change
    drop_table :rails_admin_histories
  end
end
