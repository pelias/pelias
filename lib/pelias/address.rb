module Pelias

  class Address < Base

    def initialize(params)
      @id = params[:id]
      @street_id = params[:street_id]
      @type = params[:type]
      @location = params[:location]
      @lon = @location['coordinates'][0]
      @lat = @location['coordinates'][1]
      @street_name = params[:street_name]
      @address_number = params[:address_number]
    end

    def save
      @street_id ||= get_street_id
      unless @street_id.nil?
        results = ES_CLIENT.create({
          index: 'pelias',
          type: 'address',
          id: "#{@type}-#{@id}",
          parent: @street_id,
          body: {
            properties: {
              full_name: "#{@address_number} #{@street_name}",
              street_name: @street_name,
              number: @address_number,
              location: @location
            }
          }
        })
      end
    end

    def get_street_id
      ids = get_street_ids_from_name
      get_closest_id(ids)
    end

    def get_street_ids_from_name
      begin
        latlng = Geokit::LatLng.new(@lat, @lon)
        bounds = Geokit::Bounds.from_point_and_radius(latlng, 3)
        es_results = ES_CLIENT.search(index: 'pelias', type: 'street',
          body: {
            query: {
              match: { name: @street_name }
            },
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
            },
            size: 50
          }
        )
        es_results = Hashie::Mash.new es_results
        return es_results.hits.hits.map { |hit| hit._id }
      rescue Elasticsearch::Transport::Transport::Errors::BadRequest
        return nil
      end
    end

    def get_closest_id(ids)
      return if ids.nil? || ids.empty?
      pg_results = PG_CLIENT.exec("
        SELECT osm_id, ST_Distance(
          ST_GeomFromText('POINT(#{@lon} #{@lat})', 4326),
          ST_Transform(way, 4326)) AS distance
        FROM planet_osm_line
        WHERE osm_id IN (#{ids * ','})
        ORDER BY distance ASC
      ")
      pg_results.first['osm_id']
    end

    def self.index_all
      Address.index_nodes_housenumbers
      Address.index_ways_housenumbers
      Address.index_ways_interpolations
      Address.index_rels_housenumbers
    end

    def self.index_nodes_housenumbers
      nodes_housenumbers = PG_CLIENT.exec("
        SELECT n.id, n.tags,
          ST_AsGeoJSON(ST_Transform(p.way, 4326), 6) AS location
        FROM planet_osm_nodes n
        INNER JOIN planet_osm_point p
          ON p.osm_id=n.id
        WHERE n.tags @> ARRAY['addr:housenumber']
        AND n.tags @> ARRAY['addr:street']
      ")
      nodes_housenumbers.each do |node_housenumber|
        tags = Base.parse_tags(node_housenumber['tags'])
        address = Address.new(
          :id => node_housenumber['id'],
          :type => 'node',
          :location => JSON.parse(node_housenumber['location']),
          :street_name => tags['addr:street'],
          :address_number => tags['addr:housenumber'])
        address.save
      end
    end

    def self.index_ways_housenumbers
      # if a way has a housenumber, get the closest street
      ways_housenumbers = PG_CLIENT.exec("
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
        address = Address.new(
          :id => way_housenumber['address_id'],
          :street_id => way_housenumber['street_id'],
          :type => 'way',
          :location => JSON.parse(way_housenumber['location']),
          :street_name => way_housenumber['street_name'],
          :address_number => way_housenumber['housenumber'])
        address.save
      end
    end

    def self.index_ways_interpolations
    end

    def self.index_rels_housenumbers
      rels_housenumbers = PG_CLIENT.exec("
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
        tags = Base.parse_tags(rel_housenumber['tags'])
        address = Address.new(
          :id => rel_housenumber['id'],
          :type => 'rel',
          :location => JSON.parse(rel_housenumber['location']),
          :street_name => tags['addr:street'],
          :address_number => tags['addr:housenumber'])
        address.save
      end
    end

  end

end
