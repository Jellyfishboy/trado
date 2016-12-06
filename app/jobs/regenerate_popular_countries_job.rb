class RegeneratePopularCountriesJob < ActiveJob::Base
    queue_as :default

    def perform *args
        reset_popular_countries
        set_countries
        @countries.update_all(popular: true)
    end

    private

    def reset_popular_countries
        Country.all.update_all(popular: false)
    end

    def set_countries
        @countries = Country.select('countries.*, count(DISTINCT orders.id) AS order_count').joins(:orders).group('countries.id').where(orders: { status: 0 }).order('order_count DESC').first(5)
    end
end
