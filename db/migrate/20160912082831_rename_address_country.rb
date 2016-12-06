class RenameAddressCountry < ActiveRecord::Migration
    def change
        rename_column :addresses, :country, :legacy_country
    end
end
