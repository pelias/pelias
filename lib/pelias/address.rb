module Pelias

  class Address < Base

    SUGGEST_WEIGHT = 4

    attr_accessor :id
    attr_accessor :name
    attr_accessor :number
    attr_accessor :center_point
    attr_accessor :center_shape
    attr_accessor :street_name
    attr_accessor :country_code
    attr_accessor :country_name
    attr_accessor :admin1_code
    attr_accessor :admin1_name
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
    attr_accessor :neighborhood_id
    attr_accessor :neighborhood_name
    attr_accessor :neighborhood_alternate_names
    attr_accessor :neighborhood_population

    def encompassing_shapes
      %w(admin2 local_admin locality neighborhood)
    end

    def suggest_weight
      admin_display_name ? SUGGEST_WEIGHT : 0
    end

    def admin_display_name
      locality_name || local_admin_name || neighborhood_name || admin2_name
    end

    def generate_suggestions
      input = "#{number} #{street_name}"
      output = "#{number} #{street_name}"
      if admin_display_name
        input << " #{admin_display_name}"
        output << ", #{admin_display_name}"
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

    def self.get_sql(shape)
      "SELECT osm_id AS address_id,
        \"addr:street\" AS street_name,
        \"addr:housenumber\" AS housenumber,
        ST_AsGeoJSON(ST_Transform(ST_Centroid(way), 4326), 6) AS location
      FROM planet_osm_#{shape}
      WHERE \"addr:housenumber\" IS NOT NULL
        AND \"addr:street\" IS NOT NULL
      ORDER BY osm_id"
    end

    def self.street_level?
      true
    end

  end

end
