class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :query
      t.datetime :searched_at
      t.datetime :converted_at
      t.integer :product_id

      t.timestamps
    end
  end
end
