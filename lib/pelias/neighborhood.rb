module Pelias

  class Neighborhood < Base

    SUGGEST_WEIGHT = 10

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
    # encompassing shape attributes
    attr_accessor :admin2_id
    attr_accessor :admin2_name
    attr_accessor :admin2_alternate_names
    attr_accessor :admin2_population
    attr_accessor :locality_id
    attr_accessor :locality_name
    attr_accessor :locality_alternate_names
    attr_accessor :locality_population
    attr_accessor :local_admin_id
    attr_accessor :local_admin_name
    attr_accessor :local_admin_alternate_names
    attr_accessor :local_admin_population

    def encompassing_shapes
      %w(admin2 local_admin locality)
    end

    def suggest_weight
      admin_display_name ? SUGGEST_WEIGHT : 0
    end

    def admin_display_name
      locality_name || local_admin_name || admin2_name
    end

    def suggest_input
      input = []
      input << "#{name} #{admin1_abbr}" if admin1_abbr
      input << "#{name} #{admin1_name}" if admin1_name
      [local_admin_name, locality_name, admin2_name].each do |admin_name|
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
      output = "#{name}"
      if admin_display_name
        output << ", #{admin_display_name}"
      end
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
          admin2_name: admin2_name,
          locality_name: locality_name,
          local_admin_name: local_admin_name
        }
      }
    end

  end

end
