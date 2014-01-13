class AddMetaDescriptionAndFeaturedToProducts < ActiveRecord::Migration
  def change
    add_column :products, :meta_description, :string
    add_column :products, :featured, :boolean
  end
end
