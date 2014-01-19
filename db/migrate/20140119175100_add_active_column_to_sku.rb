class AddActiveColumnToSku < ActiveRecord::Migration
  def change
    add_column :skus, :active, :boolean, :default =>  true
  end
end
