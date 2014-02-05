module Pelias

  class Locality < Base

    SUGGEST_WEIGHT = 12

    attr_accessor :id
    attr_accessor :name
    attr_accessor :alternate_names
    attr_accessor :country_code
    attr_accessor :country_name
    attr_accessor :population
    attr_accessor :admin1_code
    attr_accessor :admin1_name
    attr_accessor :center_point
    attr_accessor :center_shape
    attr_accessor :boundaries
    # encompassing shape attributes
    attr_accessor :admin2_id
    attr_accessor :admin2_name
    attr_accessor :admin2_alternate_names
    attr_accessor :admin2_population
    attr_accessor :local_admin_id
    attr_accessor :local_admin_name
    attr_accessor :local_admin_alternate_names
    attr_accessor :local_admin_population

    def encompassing_shapes
      %w(admin2 local_admin)
    end

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
      [local_admin_name, admin2_name].each do |admin_name|
        next unless admin_name
        input_name = "#{name} #{admin_name}"
        if admin1_abbr
          input_name << " #{admin1_abbr}"
        elsif admin1_name
          input_name << " #{admin1_name}"
        end
        input << input_name
      end
      input
    end

    def suggest_output
      [name, admin1_abbr || admin1_name].compact.join(', ')
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
          admin2_name: admin2_name,
          locality_name: name,
          local_admin_name: local_admin_name
        }
      }
    end

  end

end
