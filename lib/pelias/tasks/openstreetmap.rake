require 'pelias'

namespace :openstreetmap do

  task :populate_hospitals do
    results = Pelias::PG_CLIENT.exec("
      SELECT osm_id, name, website, phone,
        \"addr:street\" AS street_name,
        \"addr:housenumber\" AS housenumber,
        ST_AsGeoJSON(ST_Transform(way, 4326), 6) AS location
      FROM planet_osm_point
      WHERE amenity='hospital'
    ")
    results.each_slice(50) do |pois|
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
          :center_shape => center,
          :category => ["hospital", "healthcare", "doctor", "emergency room"]
        }
      end
      Pelias::Poi.create(bulk)
    end
  end

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

  task :populate_addresses do
    size = 100
    %w(point polygon line).each do |shape|
      Pelias::PG_CLIENT.exec("BEGIN")
      Pelias::PG_CLIENT.exec("
        DECLARE #{shape}_cursor CURSOR FOR
        #{Pelias::Address.get_sql(shape)}
      ")
      begin
        results = Pelias::PG_CLIENT.exec("FETCH #{size} FROM #{shape}_cursor")
        addresses = results.map do |result|
          center = JSON.parse(result['location'])
          {
            :id => "#{shape}-#{result['address_id']}",
            :name => "#{result['housenumber']} #{street_name}",
            :number => result['housenumber'],
            :street_name => result['street_name'],
            :center_point => center['coordinates'],
            :center_shape => center
          }
        end
        Pelias::Address.delay.create(addresses.compact)
      end while results.count > 0
      Pelias::PG_CLIENT.exec("CLOSE #{shape}_cursor")
      Pelias::PG_CLIENT.exec("COMMIT")
    end
  end

end
