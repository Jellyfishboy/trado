class CreateTiers < ActiveRecord::Migration
  def change
    create_table :tiers do |t|
      t.decimal :length_start
      t.decimal :length_end
      t.decimal :weight_start
      t.decimal :weight_end
      t.decimal :thickness_start
      t.decimal :thickness_end

      t.timestamps
    end
  end
end
