class DefaultValueForAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :default, :boolean, :default => false
  end
end
