class RemoveLanguageAndIsoAttributesFromCountries < ActiveRecord::Migration
  def change
    remove_column :countries, :language
    remove_column :countries, :iso
  end
end
