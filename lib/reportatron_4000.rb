module Reportatron4000

    class << self

        def parse_count_per_month hash
            hash = Hash[ hash.keys.map(&:to_i).zip(hash.values) ]
            return Hash[(1...13).map { |month| [ month.to_i, 0] }].merge(hash).values
        end
    end
end