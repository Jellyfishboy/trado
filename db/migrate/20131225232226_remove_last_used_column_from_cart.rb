class RemoveLastUsedColumnFromCart < ActiveRecord::Migration
  def change
    remove_column :carts, :last_used
  end
end
