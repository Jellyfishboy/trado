class ChangePartNumberProductAccessoryToString < ActiveRecord::Migration
    def change
        change_column :products, :part_number, :string
        change_column :accessories, :part_number, :string
    end
end
