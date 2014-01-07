class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.string :type
      t.string :measurement

      t.timestamps
    end
  end
end
