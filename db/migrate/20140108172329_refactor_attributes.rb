class RefactorAttributes < ActiveRecord::Migration
  def change
    drop_table :attribute_values
    add_column :skus, :attribute_value, :string
    add_column :skus, :attribute_type_id, :integer
  end
end
