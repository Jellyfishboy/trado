class RemoveMeasurementColumnFromAttributeTypeTable < ActiveRecord::Migration
  def change
    remove_column :attribute_types, :measurement
  end
end
