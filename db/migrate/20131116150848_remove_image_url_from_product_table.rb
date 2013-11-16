class RemoveImageUrlFromProductTable < ActiveRecord::Migration
  def change
  	remove_column :products, :image_url
  end
end
