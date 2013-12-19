module Pelias

  class Street < Base

    SUGGEST_WEIGHT = 8

    attr_accessor :id 
    attr_accessor :name
    attr_accessor :center_point
    attr_accessor :center_shape
    attr_accessor :boundaries
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
      (locality_name || local_admin_name) ? SUGGEST_WEIGHT : 0
    end

    def generate_suggestions
      input = "#{name}"
      output = "#{name}"
      if local_admin_name
        input << " #{local_admin_name}"
        output << ", #{local_admin_name}"
      elsif locality_name
        input << " #{locality_name}"
        output << ", #{locality_name}"
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

    def self.all_streets_sql
      "SELECT osm_id, name,
        ST_AsGeoJSON(ST_Transform(way, 4326), 6) AS street,
        ST_AsGeoJSON(ST_Transform(ST_LineInterpolatePoint(way, 0.5), 4326), 6)
          AS center
      FROM planet_osm_line
      WHERE name IS NOT NULL AND highway IS NOT NULL"
    end

    def self.street_level?
      true
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
