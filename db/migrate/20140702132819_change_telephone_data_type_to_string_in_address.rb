class ChangeTelephoneDataTypeToStringInAddress < ActiveRecord::Migration
  def change
    change_column :addresses, :telephone, :string
  end
end
