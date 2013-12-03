require 'pelias'

namespace :openstreetmap do

  desc "populate streets from OSM"
  task :populate_streets do
    limit = 50
    offset = 0
    begin
      streets = Pelias::PG_CLIENT.exec("
        SELECT osm_id, name,
          ST_AsGeoJSON(ST_Transform(way, 4326), 6) AS street,
          ST_AsGeoJSON(ST_Transform(ST_Line_Interpolate_Point(way, 0.5),
            4326), 6) AS center
        FROM planet_osm_line
        WHERE name IS NOT NULL AND highway IS NOT NULL
        LIMIT #{limit} OFFSET #{offset}
      ")
      offset += streets.count
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
  end

  desc "populate addresses from OSM"
  task :populate_addresses do
    Pelias::Osm.all_addresses.each do |address|
      address_id = address['address_id']
      location = JSON.parse(address['location'])
      street_name = address['street_name']
      number = address['housenumber']
      street_id = address['street_id'] || Pelias::Osm.get_street_id(
        street_name,
        location['coordinates'][1],
        location['coordinates'][0]
      )
      Pelias::Address.create(
        :id => address_id,
        :number => number,
        :location => location,
        :street_id => street_id,
        :street_name => street_name
      )
    end
  end

  desc "add localities to streets & addresses"
  task :add_localities do
    completed_results = 0
    begin
      results = Pelias::ES_CLIENT.search(index: 'pelias', type: 'locality',
        from: completed_results)
      results['hits']['hits'].each do |result|
        locality = Pelias::Locality.find(result['_id'])
        locality.all_addresses.each do |address|
          address = Pelias::Address.find(address['_id'])
          address.update_attributes(
            :locality_id => locality.id,
            :locality_name => locality.name,
            :locality_alternate_names => locality.alternate_names,
            :locality_country_code => locality.country_code,
            :locality_admin1_code => locality.admin1_code,
            :locality_admin2_code => locality.admin2_code,
            :locality_admin3_code => locality.admin3_code,
            :locality_admin4_code => locality.admin4_code,
            :locality_population => locality.population
          )
        end
        locality.all_streets.each do |street|
          street = Pelias::Street.find(street['_id'])
        end
        completed_results += 1
      end
      total_results = results['hits']['total']
    end while completed_results < total_results
  end

end
