module Pelias

  class Geoname < Location

    def suggest_input
      name
    end

    def suggest_output
      name
    end

    def suggest_weight
      0
    end

  end

end
