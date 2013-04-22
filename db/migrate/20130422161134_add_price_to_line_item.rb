class AddPriceToLineItem < ActiveRecord::Migration
  def self.up

    add_column :line_items, :price, :decimal
    LineItem.reset_column_information

    LineItem.all.each do |li|
      li.update_attribute :price, li.product.price
    end

  end

  def self.down
    remove_column :line_items, :price
  end
end