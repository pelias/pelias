module Pelias

  class Osm < Base

    def self.all_addresses
      addresses = Pelias::Osm.nodes_housenumbers.map { |r| r }
      addresses += Pelias::Osm.ways_housenumbers.map { |r| r }
      #addresses += Pelias::Osm.ways_interpolations.map { |r| r }
      addresses += Pelias::Osm.rels_housenumbers.map { |r| r }
      addresses
    end

    def self.nodes_housenumbers
      PG_CLIENT.exec("
        SELECT
          n.id AS address_id,
          tags[idx(n.tags, 'addr:street') + 1] AS street_name,
          tags[idx(n.tags, 'addr:housenumber') + 1] AS housenumber,
          ST_AsGeoJSON(ST_Transform(p.way, 4326), 6) AS location
        FROM planet_osm_nodes n
        INNER JOIN planet_osm_point p
          ON p.osm_id=n.id
        WHERE n.tags @> ARRAY['addr:housenumber']
        AND n.tags @> ARRAY['addr:street']
      ")
    end

    def self.ways_housenumbers
      PG_CLIENT.exec("
        SELECT DISTINCT ON (address_id)
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
          AND ST_Distance(l1.way, l2.way) > 0
        ORDER BY address_id, distance ASC
      ")
    end

    def self.ways_interpolations
      # TODO
    end

    def self.rels_housenumbers
      PG_CLIENT.exec("
        SELECT r.id AS address_id,
          tags[idx(r.tags, 'addr:street') + 1] AS street_name,
          tags[idx(r.tags, 'addr:housenumber') + 1] AS housenumber,
          ST_AsGeoJSON(ST_Transform(ST_Centroid(
            ST_Union(l.way)), 4326), 6) AS location
        FROM planet_osm_rels r
        INNER JOIN planet_osm_line l
          ON r.parts @> ARRAY[l.osm_id]
        WHERE r.tags @> ARRAY['addr:housenumber']
        AND r.tags @> ARRAY['addr:street']
        GROUP BY r.id
      ")
    end

    def self.get_street_id(street_name, lat, lon)
      return if street_name.nil? || street_name==''
      ids = Pelias::Osm.get_street_ids_from_name(street_name, lat, lon)
      Pelias::Osm.get_closest_id(ids, lat, lon)
    end

    def self.get_street_ids_from_name(street_name, lat, lon)
      latlng = Geokit::LatLng.new(lat, lon)
      bounds = Geokit::Bounds.from_point_and_radius(latlng, 3)
      ne = [bounds.ne.lng.round(6), bounds.ne.lat.round(6)]
      sw = [bounds.sw.lng.round(6), bounds.sw.lat.round(6)]
      es_results = Pelias::ES_CLIENT.search(index: 'pelias',
        type: 'street', size: 50, body: {
          query: { match: { name: street_name } },
          filter: {
            geo_shape: {
              center_point:{shape:{type:'envelope',coordinates:[ne, sw]}}
            }
          }
        }
      )
      es_results['hits']['hits'].map { |hit| hit['_id'] }
    end

    def self.get_closest_id(ids, lat, lon)
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
