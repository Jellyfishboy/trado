class RegeneratePopularCountriesJob < ActiveJob::Base
    queue_as :default

    def perform *args
        set_countries
        @countries.map{|c| c.update_column(:popular, true) }
    end

    private

    def set_countries
        @countries = Country.joins(:orders).group("countries.id").order("count(countries.id) DESC").first(10)
    end
end
