class DropPayTypeTable < ActiveRecord::Migration
  def change
    drop_table :pay_types
  end
end
