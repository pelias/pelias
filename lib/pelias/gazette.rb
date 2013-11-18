module Pelias

  class Gazette < Base

    attr_accessor :id
    attr_accessor :name
    attr_accessor :alternate_names
    attr_accessor :center_point
    attr_accessor :center_shape
    attr_accessor :feature_class
    attr_accessor :feature_code
    attr_accessor :country_code
    attr_accessor :country_name
    attr_accessor :admin1_code
    attr_accessor :admin1_name
    attr_accessor :admin2_code
    attr_accessor :admin2_name
    attr_accessor :admin3_code
    attr_accessor :admin4_code
    attr_accessor :population

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
