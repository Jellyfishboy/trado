class MigrateStockadjustmentDatetimesJob < ActiveJob::Base
    queue_as :default

    def perform
        StockAdjustment.all.each do |sa|
            sa.adjusted_at = sa.created_at
            sa.duplicate = true
            sa.save!
        end
    end
end