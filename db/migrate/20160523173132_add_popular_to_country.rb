class AddPopularToCountry < ActiveRecord::Migration
    def change
        add_column :countries, :popular, :boolean, default: false
    end
end
