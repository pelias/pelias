module Pelias

  class Poi < Base

    attr_accessor *%i[
      id
      name
      number
      phone
      website
      category
      center_point
      center_shape
      street_id
      street_name
      local_admin_id
      local_admin_name
      local_admin_alternate_names
      local_admin_population
      locality_id
      locality_name
      locality_alternate_names
      locality_population
      neighborhood_id
      neighborhood_name
      neighborhood_alternate_names
      neighborhood_population
      country_code
      country_name
      admin1_code
      admin1_name
      admin2_code
      admin2_name
    ]

    def encompassing_shapes
      %w(local_admin locality neighborhood)
    end

    def suggest_weight
      (locality_name || local_admin_name) ? 3 : 0
    end

    def generate_suggestions
      input = "#{name}"
      output = "#{name}"
      if number && street_name
        input << " #{number} #{street_name}"
        output << " - #{number} #{street_name}"
      end
      if local_admin_name
        input << " #{local_admin_name}"
        output << " - #{local_admin_name}"
      elsif locality_name
        input << " #{locality_name}"
        output << " - #{locality_name}"
      end
      if admin1_abbr
        input << " #{admin1_abbr}"
        output << ", #{admin1_abbr}"
      elsif admin1_name
        input << " #{admin1_name}"
        output << ", #{admin1_name}"
      end
      {
        input: input,
        output: output,
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

    def self.street_level?
      true
    end

  end

end
