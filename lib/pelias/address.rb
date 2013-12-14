module Pelias

  class Address < Base

    attr_accessor *%i[
      id
      name
      number
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

    def generate_suggestions
      input = "#{number} #{street_name}"
      output = "#{number} #{street_name}"
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
        weight: 2,
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

    def self.point_housenumbers_sql
      'SELECT osm_id AS address_id,
        "addr:street" AS street_name,
        "addr:housenumber" AS housenumber,
        ST_AsGeoJSON(ST_Transform(way, 4326), 6) AS location
      FROM planet_osm_point
      WHERE "addr:housenumber" IS NOT NULL
        AND "addr:street" IS NOT NULL'
    end

    def self.polygon_housenumbers_sql
      'SELECT osm_id AS address_id,
        "addr:street" AS street_name,
        "addr:housenumber" AS housenumber,
        ST_AsGeoJSON(ST_Transform(ST_Centroid(way), 4326), 6) AS location
      FROM planet_osm_polygon
      WHERE "addr:housenumber" IS NOT NULL
        AND "addr:street" IS NOT NULL'
    end

    def self.line_housenumbers_sql
      "SELECT DISTINCT ON (address_id)
        l1.osm_id AS address_id,
        l2.osm_id AS street_id,
        l1.\"addr:housenumber\" AS housenumber,
        l2.name AS street_name,
        ST_Distance(l1.way, l2.way) AS distance,
        ST_AsGeoJSON(ST_Transform(ST_Centroid(l1.way), 4326), 6) AS location
      FROM planet_osm_ways w
      INNER JOIN planet_osm_line l1
        ON l1.osm_id=w.id
      INNER JOIN planet_osm_line l2
        ON ST_DWithin(l1.way, l2.way, 100)
        AND l2.name IS NOT NULL
        AND l2.highway IS NOT NULL
      WHERE w.tags @> ARRAY['addr:housenumber']
        AND w.tags @> ARRAY['addr:street']
        AND ST_Distance(l1.way, l2.way) > 0
      ORDER BY address_id, distance ASC"
    end

    def self.addresses_ways_interpolations_sql
      # TODO
    end

    def self.street_level?
      true
    end

  end

end
