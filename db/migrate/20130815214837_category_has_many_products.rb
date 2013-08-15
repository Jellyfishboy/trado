class CategoryHasManyProducts < ActiveRecord::Migration
  def up
    create_table :categories do |t|
        t.integer :product_id
        t.string :title
        t.text :description
        t.string :image_url

        t.timestamps
    end
  end

  def down
    drop_table :categories
  end
end
