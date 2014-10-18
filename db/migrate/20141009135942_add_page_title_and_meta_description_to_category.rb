class AddPageTitleAndMetaDescriptionToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :page_title, :string
    add_column :categories, :meta_description, :string
  end
end
