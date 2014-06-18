class RenameDefaultFieldInAttachments < ActiveRecord::Migration
  def change
    rename_column :attachments, :default, :default_record
  end
end
