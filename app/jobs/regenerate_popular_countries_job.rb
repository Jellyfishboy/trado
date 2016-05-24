class RegeneratePopularCountriesJob < ActiveJob::Base
    queue_as :default

    def perform *args
        reset_popular_countries
        set_countries
        @countries.map{|c| c.update_column(:popular, true) }
    end

    private

    def reset_popular_countries
        Country.all.update_all(popular: false)
    end

    def set_countries
        @countries = Country.joins(:orders).group("countries.id").order("count(countries.id) DESC").first(5)
    end
end
