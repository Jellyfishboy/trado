class AddVatNumberAndVatApplicableAndTelephoneToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :telephone, :integer
    add_column :invoices, :vat_number, :integer
    add_column :invoices, :vat_applicable, :boolean
  end
end
