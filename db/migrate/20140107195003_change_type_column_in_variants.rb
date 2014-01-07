class ChangeTypeColumnInVariants < ActiveRecord::Migration
  def change
    rename_column :variants, :type, :name
  end
end
