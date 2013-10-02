class ChangePartNumberDataTypeToIntegerInAccessoriesTable < ActiveRecord::Migration
  def change
    change_column :accessories, :part_number, :integer
  end
end
