class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.text :content
      t.string :page_title
      t.string :meta_description
      t.boolean :visible

      t.timestamps
    end
  end
end
