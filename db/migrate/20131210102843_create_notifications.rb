class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :email
      t.integer :dimension_id

      t.timestamps
    end
  end
end
