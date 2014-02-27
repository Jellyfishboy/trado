class UpdatePartNumberToStringDataType < ActiveRecord::Migration
  def change
    change_column :products, :part_number, :string
  end
end
