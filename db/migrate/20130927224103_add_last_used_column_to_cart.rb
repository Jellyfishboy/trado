class AddLastUsedColumnToCart < ActiveRecord::Migration
  def change
    add_column :carts, :last_used, :datetime
  end
end
