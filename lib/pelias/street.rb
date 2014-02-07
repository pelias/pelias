module Pelias

  class Street < Location

    SUGGEST_WEIGHT = 8

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
      input = []
      input << "#{name} #{local_admin_name}" if local_admin_name
      input << "#{name} #{locality_name}" if locality_name
      input << "#{name} #{neighborhood_name}" if neighborhood_name
      input << "#{name} #{admin2_name}" if admin2_name
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

    def self.all_streets_sql
      "SELECT osm_id, name,
        ST_AsGeoJSON(ST_Transform(way, 4326), 6) AS street,
        ST_AsGeoJSON(ST_Transform(ST_LineInterpolatePoint(way, 0.5), 4326), 6)
          AS center
      FROM planet_osm_line
      WHERE name IS NOT NULL AND highway IS NOT NULL
      ORDER BY osm_id"
    end

    def self.get_street(street_name, lat, lon)
      return if street_name.nil? || street_name==''
      ids = Pelias::Osm.get_street_ids_from_name(street_name, lat, lon)
      id = Pelias::Osm.get_closest_id(ids, lat, lon)
      id.nil? ? nil : Pelias::Street.find(id)
    end

    def self.get_street_ids_from_name(street_name, lat, lon)
      # get matching name streets with a center point 10 km away from address
      es_results = Pelias::ES_CLIENT.search(index: Pelias::INDEX,
        type: 'street', size: 50, body: {
          query: { match: { name: street_name } },
          filter: {
            geo_distance: {
              distance: 10,
              distance_unit: 'km',
              center_point: [lon, lat]
            }
          }
        }
      )
      es_results['hits']['hits'].map { |hit| hit['_id'] }
    end

    def self.get_closest_id(ids, lat, lon)
      # use PG to sort streets by shape, ES doesn't support this yet
      return if ids.nil? || ids.empty?
      pg_results = Pelias::PG_CLIENT.exec("
        SELECT osm_id, ST_Distance(
          ST_GeomFromText('POINT(#{lon} #{lat})', 4326),
          ST_Transform(way, 4326)) AS distance
        FROM planet_osm_line
        WHERE osm_id IN (#{ids * ','})
        ORDER BY distance ASC
      ")
      pg_results.first['osm_id']
    end

  end

end
