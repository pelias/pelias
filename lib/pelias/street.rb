module Pelias

  class Street < Location

    SUGGEST_WEIGHT = 8

    def suggest_weight
      admin_display_name ? SUGGEST_WEIGHT : 0
    end

    def admin_display_name
      containing_names.first
    end

    def suggest_input
      containing_names.map { |val| "#{name} #{val}" }
    end

    def suggest_output
      [name, admin_display_name, admin1_abbr || admin1_name].compact.join(', ')
    end

    def self.all_streets_sql
      "SELECT osm_id, name,
        ST_AsGeoJSON(ST_Transform(way, 4326), 6) AS street,
        ST_AsGeoJSON(ST_Transform(ST_LineInterpolatePoint(way, 0.5), 4326), 6) AS center
      FROM planet_osm_line
      WHERE name IS NOT NULL AND highway IS NOT NULL
      ORDER BY osm_id"
    end

    private

    # @return array containing names in order of closeness
    def containing_names
      [local_admin_name, locality_name, neighborhood_name, admin2_name].compact
    end

  end

end
