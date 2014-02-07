module Pelias

  class Address < Location

    SUGGEST_WEIGHT = 4

    def encompassing_shapes
      %w(admin2 local_admin locality neighborhood)
    end

    def suggest_weight
      admin_display_name ? SUGGEST_WEIGHT : 0
    end

    def admin_display_name
      local_admin_name || locality_name || neighborhood_name || admin2_name
    end

    def suggest_input
      base = "#{number} #{street_name}"
      input = [base]
      input << "#{base} #{local_admin_name}" if local_admin_name
      input << "#{base} #{locality_name}" if locality_name
      input << "#{base} #{neighborhood_name}" if neighborhood_name
      input << "#{base} #{admin2_name}" if admin2_name
      input
    end

    def suggest_output
      output = "#{number} #{street_name}"
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

  end

end
