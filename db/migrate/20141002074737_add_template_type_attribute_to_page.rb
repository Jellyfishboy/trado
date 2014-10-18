class AddTemplateTypeAttributeToPage < ActiveRecord::Migration
  def change
    add_column :pages, :template_type, :integer
  end
end
