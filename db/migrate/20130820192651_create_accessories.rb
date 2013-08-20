class CreateAccessories < ActiveRecord::Migration
  def change
    create_table :accessories do |t|
      t.string :name
      t.decimal :price

      t.timestamps
    end
  end
end
