module Pelias

  class Admin2 < Base

    SUGGEST_WEIGHT = 2

    attr_accessor :id
    attr_accessor :name
    attr_accessor :alternate_names
    attr_accessor :country_code
    attr_accessor :country_name
    attr_accessor :admin1_code
    attr_accessor :admin1_name
    attr_accessor :population
    attr_accessor :center_point
    attr_accessor :center_shape
    attr_accessor :boundaries

    def suggest_weight
      SUGGEST_WEIGHT + population_weight_boost
    end

    def population_weight_boost
      return 0 if population.nil?
      boost = population.to_i / 100000
      boost < 1 ? 1 : boost.to_i
    end

    def suggest_input
      input = []
      input << "#{name} #{admin1_abbr}" if admin1_abbr
      input << "#{name} #{admin1_name}" if admin1_name
      input
    end

    def suggest_output
      output = "#{name}"
      if admin1_abbr
        output << ", #{admin1_abbr}"
      elsif admin1_name
        output << ", #{admin1_name}"
      end
      output
    end

    def generate_suggestions
      {
        input: suggest_input,
        output: suggest_output,
        weight: suggest_weight,
        payload: {
          lat: lat,
          lon: lon,
          type: type,
          country_code: country_code,
          country_name: country_name,
          admin1_abbr: admin1_abbr,
          admin1_name: admin1_name,
          admin2_name: name,
          locality_name: nil,
          local_admin_name: nil
        }
      }
    end

  end

end
