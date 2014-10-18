class DropSearchesTable < ActiveRecord::Migration
  def change
    drop_table :searches
  end
end
