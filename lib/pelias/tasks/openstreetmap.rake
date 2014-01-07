require 'pelias'

namespace :openstreetmap do

  task :populate_pois do
    i = 0
    size = 10
    %w(point polygon line).each do |shape|
      Pelias::PG_CLIENT.exec("BEGIN")
      Pelias::PG_CLIENT.exec("
        DECLARE poi_#{shape}_cursor CURSOR FOR
        #{Pelias::Poi.get_sql(shape)}
      ")
      begin
        puts "#{shape} #{i}"
        i+=size
        results = Pelias::PG_CLIENT.exec("FETCH #{size} FROM poi_#{shape}_cursor")
        pois = results.map do |result|
          Pelias::Poi.create_hash(result, shape)
        end
        if i >= 0
          begin
            Pelias::Poi.delay.create(pois.compact)
          rescue
            sleep 20
            Pelias::Poi.delay.create(pois.compact)
          end
        end
      end while results.count > 0
      Pelias::PG_CLIENT.exec("CLOSE poi_#{shape}_cursor")
      Pelias::PG_CLIENT.exec("COMMIT")
    end
  end

  task :populate_streets do
    i = 0
    size = 50
    Pelias::PG_CLIENT.exec("BEGIN")
    Pelias::PG_CLIENT.exec("
      DECLARE streets_cursor CURSOR FOR
      #{Pelias::Street.all_streets_sql}
    ")
    begin
      puts i
      i += size
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
      if i >= 0
        begin
          Pelias::Street.delay.create(street_data)
        rescue
          sleep 20
          Pelias::Street.delay.create(street_data)
        end
      end
    end while streets.count > 0
    Pelias::PG_CLIENT.exec("CLOSE streets_cursor")
    Pelias::PG_CLIENT.exec("COMMIT")
  end

  task :populate_addresses do
    i = 0
    size = 100
    %w(point polygon line).each do |shape|
      Pelias::PG_CLIENT.exec("BEGIN")
      Pelias::PG_CLIENT.exec("
        DECLARE address_#{shape}_cursor CURSOR FOR
        #{Pelias::Address.get_sql(shape)}
      ")
      begin
        puts "#{shape} #{i}"
        i+=size
        results = Pelias::PG_CLIENT.exec("FETCH #{size} FROM address_#{shape}_cursor")
        addresses = results.map do |result|
          center = JSON.parse(result['location'])
          {
            :id => "#{shape}-#{result['address_id']}",
            :name => "#{result['housenumber']} #{result['street_name']}",
            :number => result['housenumber'],
            :street_name => result['street_name'],
            :center_point => center['coordinates'],
            :center_shape => center
          }
        end
        if i >= 0
          begin
            Pelias::Address.delay.create(addresses.compact)
          rescue
            sleep 20
            Pelias::Address.delay.create(addresses.compact)
          end
        end
      end while results.count > 0
      Pelias::PG_CLIENT.exec("CLOSE address_#{shape}_cursor")
      Pelias::PG_CLIENT.exec("COMMIT")
    end
  end

end
