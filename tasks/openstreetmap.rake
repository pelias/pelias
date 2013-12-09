require 'pelias'

namespace :openstreetmap do

  desc "populate streets from OSM"
  task :populate_streets do
    Pelias::PG_CLIENT.exec("BEGIN")
    Pelias::PG_CLIENT.exec("
      DECLARE streets_cursor CURSOR FOR
      #{Pelias::Osm.streets_sql}
    ")
    begin
      streets = Pelias::PG_CLIENT.exec("FETCH 50 FROM streets_cursor")
      exists = Pelias::ES_CLIENT.get(index: 'pelias', type: 'streets',
        id: streets.first['osm_id'], ignore: 404)
      next if exists
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
    nodes_housenumbers
    ways_housenumbers
    ways_interpolations
    rels_housenumbers
  end

  def nodes_housenumbers
    Pelias::PG_CLIENT.exec("BEGIN")
    Pelias::PG_CLIENT.exec("
      DECLARE nh_cursor CURSOR FOR
      #{Pelias::Osm.addresses_nodes_housenumbers_sql}
    ")
    begin
      addresses = Pelias::PG_CLIENT.exec("FETCH 500 FROM nh_cursor")
      address_data = addresses.map do |address|
        center = JSON.parse(address['location'])
        street_name = address['street_name']
        street_id = Pelias::Osm.get_street_id(
          street_name,
          center['coordinates'][1],
          center['coordinates'][0]
        )
        if street_id
          {
            :id => address['address_id'],
            :number => address['housenumber'],
            :street_id => street_id,
            :street_name => street_name,
            :center_point => center['coordinates'],
            :center_shape => center
          }
        else 
          nil
        end
      end
      Pelias::Address.delay.create(address_data.compact)
    end while addresses.count > 0
    Pelias::PG_CLIENT.exec("CLOSE nh_cursor")
    Pelias::PG_CLIENT.exec("COMMIT")
  end

  def ways_housenumbers
  end

  def ways_interpolations
  end

  def rels_housenumbers
  end

end
