class AddAlphaTwoCodeToCountry < ActiveRecord::Migration
  def change
    add_column :countries, :alpha_two_code, :string
  end
end
