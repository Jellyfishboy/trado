class DropDimensionalsTable < ActiveRecord::Migration
  def change
    drop_table :dimensionals
  end
end
