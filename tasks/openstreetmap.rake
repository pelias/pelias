require 'pelias'

namespace :openstreetmap do

  desc "setup index & mappings"
  task :setup do
    schema_file = File.read('schemas/openstreetmap.json')
    schema_json = JSON.parse(schema_file)
    Pelias::Base::ES_CLIENT.indices.create(index: 'openstreetmap',
      body: schema_json)
  end

  desc "populate streets from osm"
  task :populate_streets do
    streets = Pelias::Base::PG_CLIENT.exec("
      SELECT osm_id, name,
        ST_AsGeoJSON(ST_Transform(way, 4326), 6) AS location
      FROM planet_osm_line
      WHERE name IS NOT NULL AND highway IS NOT NULL
    ")
    streets.each do |street|
      Pelias::Base::ES_CLIENT.index(index: 'openstreetmap', type: 'street',
        id: street['osm_id'], body: {
          name: street['name'],
          location: JSON.parse(street['location'])
        }
      )
    end
  end

  desc "populate addresses from osm"
  task :populate_addresses do
    index_nodes_housenumbers
    index_ways_housenumbers
    index_ways_interpolations
    index_rels_housenumbers
  end

  def index_nodes_housenumbers
    nodes_housenumbers = Pelias::Base::PG_CLIENT.exec("
      SELECT n.id, n.tags,
        ST_AsGeoJSON(ST_Transform(p.way, 4326), 6) AS location
      FROM planet_osm_nodes n
      INNER JOIN planet_osm_point p
        ON p.osm_id=n.id
      WHERE n.tags @> ARRAY['addr:housenumber']
      AND n.tags @> ARRAY['addr:street']
    ")
    nodes_housenumbers.each do |node_housenumber|
      id = node_housenumber['id']
      tags = Pelias::Osm.parse_tags(node_housenumber['tags'])
      street_name = tags['addr:street']
      address_number = tags['addr:housenumber']
      location = JSON.parse(node_housenumber['location'])
      lon = location['coordinates'][0]
      lat = location['coordinates'][1]
      street_id = get_street_id(street_name, lat, lon)
      index_address(:id => id, :type => 'node', :location => location,
        :address_number => address_number, :street_id => street_id)
    end
  end

  def index_ways_housenumbers
    # if a way has a housenumber, get the closest street
    ways_housenumbers = Pelias::Base::PG_CLIENT.exec("
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
    ways_housenumbers.each do |way_housenumber|
      id = way_housenumber['address_id']
      street_id = way_housenumber['street_id']
      address_number = way_housenumber['housenumber']
      location = JSON.parse(way_housenumber['location'])
      index_address(:id => id, :type => 'way', :location => location,
        :address_number => address_number, :street_id => street_id)
    end
  end

  def index_ways_interpolations
    # TODO (lazy)
  end

  def index_rels_housenumbers
    rels_housenumbers = Pelias::Base::PG_CLIENT.exec("
      SELECT r.id, r.tags,
        ST_AsGeoJSON(ST_Transform(ST_Centroid(
        ST_Union(l.way)), 4326), 6) AS location
      FROM planet_osm_rels r
      INNER JOIN planet_osm_line l
        ON r.parts @> ARRAY[l.osm_id]
      WHERE r.tags @> ARRAY['addr:housenumber']
      AND r.tags @> ARRAY['addr:street']
      GROUP BY r.id
    ")
    rels_housenumbers.each do |rel_housenumber|
      id = rel_housenumber['id']
      tags = Pelias::Osm.parse_tags(rel_housenumber['tags'])
      location = JSON.parse(rel_housenumber['location'])
      street_name = tags['addr:street']
      address_number = tags['addr:housenumber']
      street_id = get_street_id(street_name, lat, lon)
      index_address(:id => id, :type => 'rel', :location => location,
        :address_number => address_number, :street_id => street_id)
    end
  end

  def index_address(params)
    return if params[:address_number].nil? || params[:street_id].nil?
    Pelias::Base::ES_CLIENT.create({
      index: 'openstreetmap', type: 'address', parent: params[:street_id],
      id: "#{params[:type]}-#{params[:id]}",
      body: {
        properties: {
          number: params[:address_number],
          location: params[:location]
        }
      }
    })
  end

  def get_street_id(street_name, lat, lon)
    return if street_name.nil? || street_name==''
    ids = get_street_ids_from_name(street_name, lat, lon)
    get_closest_id(ids, lat, lon)
  end

  def get_street_ids_from_name(street_name, lat, lon)
    begin
      latlng = Geokit::LatLng.new(lat, lon)
      bounds = Geokit::Bounds.from_point_and_radius(latlng, 3)
      es_results = Pelias::Base::ES_CLIENT.search(index: 'openstreetmap',
        type: 'street', size: 50, body: {
          query: { match: { name: street_name } },
          filter: {
            geo_shape: {
              location: {
                shape: {
                  type: 'envelope',
                  coordinates: [
                    [bounds.ne.lng.round(6), bounds.ne.lat.round(6)],
                    [bounds.sw.lng.round(6), bounds.sw.lat.round(6)]
                  ]
                }
              }
            }
          }
        }
      )
      es_results = Hashie::Mash.new es_results
      return es_results.hits.hits.map { |hit| hit._id }
    rescue Elasticsearch::Transport::Transport::Errors::BadRequest
      return nil
    end
  end

  def get_closest_id(ids, lat, lon)
    return if ids.nil? || ids.empty?
    pg_results = Pelias::Base::PG_CLIENT.exec("
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
