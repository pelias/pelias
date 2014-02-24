module Pelias

  class Street < Location
    def self.all_streets_sql
      "SELECT osm_id, name,
        ST_AsGeoJSON(ST_Transform(way, 4326), 6) AS street,
        ST_AsGeoJSON(ST_Transform(ST_LineInterpolatePoint(way, 0.5), 4326), 6) AS center
      FROM planet_osm_line
      WHERE name IS NOT NULL AND highway IS NOT NULL
      ORDER BY osm_id"
    end

  end

end
