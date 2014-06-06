class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :user_id
      t.integer :role_id

      t.timestamps
    end
  end
end
