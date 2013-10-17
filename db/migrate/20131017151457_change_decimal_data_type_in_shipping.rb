class ChangeDecimalDataTypeInShipping < ActiveRecord::Migration
  def change
    change_column :shippings, :price, :decimal, :precision => 8, :scale => 2
  end
end
