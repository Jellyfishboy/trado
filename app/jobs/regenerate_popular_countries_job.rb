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
        @countries = Country.joins(:orders).group("countries.id").order("count(countries.id) DESC").limit(5)
    end
end
