class RemovePaypalExpressAttributes < ActiveRecord::Migration
    def change
        remove_column :orders, :express_token
        remove_column :orders, :express_payer_id
    end
end
