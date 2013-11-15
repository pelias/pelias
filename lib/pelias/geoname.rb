module Pelias

  class Geoname < Base

    attr_accessor :id
    attr_accessor :name
    attr_accessor :alternate_names
    attr_accessor :location
    attr_accessor :feature_class
    attr_accessor :feature_code
    attr_accessor :country_code
    attr_accessor :admin1_code
    attr_accessor :admin2_code
    attr_accessor :admin3_code
    attr_accessor :admin4_code
    attr_accessor :population
    attr_accessor :elevation

    def lat
      (@location['coordinates'] || @location[:coordinates])[1].to_f
    end

    def lon
      (@location['coordinates'] || @location[:coordinates])[0].to_f
    end

    private

    def generate_suggestions
      # TODO take into account alternate names, admin heirarchy
      return {
        input: @name,
        output: @name,
        payload: { lat: lat, lon: lon, type: type }
      }
    end

  end

end
