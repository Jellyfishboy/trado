class RemoveRedactorAssetsTable < ActiveRecord::Migration
  def change
    drop_table :redactor_assets
  end
end
