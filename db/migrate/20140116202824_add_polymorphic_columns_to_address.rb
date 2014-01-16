class AddPolymorphicColumnsToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :addressable_id, :integer
    add_column :addresses, :addressable_type, :string
  end
end
