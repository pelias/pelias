module Pelias

  class LocalAdmin < Base

    attr_accessor :id
    attr_accessor :name
    attr_accessor :alternate_names
    attr_accessor :country_code
    attr_accessor :country_name
    attr_accessor :admin1_code
    attr_accessor :admin1_name
    attr_accessor :admin2_code
    attr_accessor :admin2_name
    attr_accessor :admin3_code
    attr_accessor :admin4_code
    attr_accessor :population
    attr_accessor :locality_id
    attr_accessor :locality_name
    attr_accessor :locality_alternate_names
    attr_accessor :locality_population
    attr_accessor :center_point
    attr_accessor :center_shape
    attr_accessor :boundaries

    def encompassing_shapes
      %w(locality)
    end

    def population_weight_boost
      return 0 if population.nil?
      boost = population.to_i / 100000
      boost < 1 ? 1 : boost.to_i
    end

    def generate_suggestions
      input = "#{name}"
      output = "#{name}"
      if admin1_abbr
        input << " #{admin1_abbr}"
        output << ", #{admin1_abbr}"
      elsif admin1_name
        input << " #{admin1_name}"
        output << ", #{admin1_name}"
      end
      return {
        input: input,
        output: output,
        weight: 10 + population_weight_boost,
        payload: {
          lat: lat,
          lon: lon,
          type: type,
          country_code: country_code,
          country_name: country_name,
          admin1_abbr: admin1_abbr,
          admin1_name: admin1_name,
          admin2_name: admin2_name,
          locality_name: locality_name,
          local_admin_name: nil
        }
      }
    end

  end

end
