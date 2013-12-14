require 'pelias'

namespace :openstreetmap do

  task :populate_pizza_pois do
    Pelias::Osm.create_postgres_index_function
    results = Pelias::PG_CLIENT.exec("
      SELECT p.osm_id,
        n.tags[idx(n.tags, 'name') + 1] AS name,
        n.tags[idx(n.tags, 'website') + 1] AS website,
        n.tags[idx(n.tags, 'phone') + 1] AS phone,
        n.tags[idx(n.tags, 'addr:street') + 1] AS street_name,
        n.tags[idx(n.tags, 'addr:housenumber') + 1] AS housenumber,
        ST_AsGeoJSON(ST_Transform(p.way, 4326), 6) AS location
      FROM planet_osm_nodes n
      INNER JOIN planet_osm_point p
        ON p.osm_id=n.id
      WHERE n.tags @> ARRAY['pizza']
    ")
    results.each_slice(100) do |pois|
      bulk = pois.map do |poi|
        center = JSON.parse(poi['location'])
        {
          :id => poi['osm_id'],
          :name => poi['name'],
          :website => poi['website'],
          :phone => poi['phone'],
          :street_name => poi['street_name'],
          :number => poi['housenumber'],
          :center_point => center['coordinates'],
          :center_shape => center
        }
      end
      Pelias::Poi.create(bulk)
    end
  end

  desc "populate streets from OSM"
  task :populate_streets do
    size = 50
    Pelias::PG_CLIENT.exec("BEGIN")
    Pelias::PG_CLIENT.exec("
      DECLARE streets_cursor CURSOR FOR
      #{Pelias::Street.all_streets_sql}
    ")
    begin
      streets = Pelias::PG_CLIENT.exec("FETCH #{size} FROM streets_cursor")
      street_data = streets.map do |street|
        center = JSON.parse(street['center'])
        {
          :id => street['osm_id'],
          :name => street['name'],
          :center_point => center['coordinates'],
          :center_shape => center,
          :boundaries => JSON.parse(street['street'])
        }
      end
      Pelias::Street.delay.create(street_data)
    end while streets.count > 0
    Pelias::PG_CLIENT.exec("CLOSE streets_cursor")
    Pelias::PG_CLIENT.exec("COMMIT")
  end

  desc "populate addresses from OSM"
  task :populate_addresses do
    point_housenumbers
    polygon_housenumbers
    line_housenumbers
  end

  def point_housenumbers
    i = 0
    size = 50
    Pelias::PG_CLIENT.exec("BEGIN")
    Pelias::PG_CLIENT.exec("
      DECLARE point_cursor CURSOR FOR
      #{Pelias::Address.point_housenumbers_sql}
    ")
    begin
      puts "point #{i}"
      i += size
      addresses = Pelias::PG_CLIENT.exec("FETCH #{size} FROM point_cursor")
      address_data = addresses.map do |address|
        center = JSON.parse(address['location'])
        street_name = address['street_name']
        {
          :id => "pt-#{address['address_id']}",
          :name => "#{address['housenumber']} #{street_name}",
          :number => address['housenumber'],
          :street_name => street_name,
          :center_point => center['coordinates'],
          :center_shape => center
        }
      end
      Pelias::Address.delay.create(address_data.compact)
    end while addresses.count > 0
    Pelias::PG_CLIENT.exec("CLOSE point_cursor")
    Pelias::PG_CLIENT.exec("COMMIT")
  end

  def polygon_housenumbers
    i = 0
    size = 50
    Pelias::PG_CLIENT.exec("BEGIN")
    Pelias::PG_CLIENT.exec("
      DECLARE polygon_cursor CURSOR FOR
      #{Pelias::Address.polygon_housenumbers_sql}
    ")
    begin
      puts "polygon #{i}"
      i += size
      addresses = Pelias::PG_CLIENT.exec("FETCH #{size} FROM polygon_cursor")
      address_data = addresses.map do |address|
        center = JSON.parse(address['location'])
        street_name = address['street_name']
        {
          :id => "pg-#{address['address_id']}",
          :name => "#{address['housenumber']} #{street_name}",
          :number => address['housenumber'],
          :street_name => street_name,
          :center_point => center['coordinates'],
          :center_shape => center
        }
      end
      Pelias::Address.delay.create(address_data.compact)
    end while addresses.count > 0
    Pelias::PG_CLIENT.exec("CLOSE polygon_cursor")
    Pelias::PG_CLIENT.exec("COMMIT")
  end

  def line_housenumbers
  end

end
