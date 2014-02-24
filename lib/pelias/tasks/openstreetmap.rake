require_relative 'task_helper'

namespace :osm do

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
    r = Pelias::PG_CLIENT.exec(all_streets_count_sql)
    bar = ProgressBar.create(total: r.first['count'].to_i, format: '%e |%b>%i| %p%%')
    Pelias::PG_CLIENT.exec('BEGIN')
    Pelias::PG_CLIENT.exec("DECLARE streets_cursor CURSOR FOR #{all_streets_sql}")
    begin
      streets = Pelias::PG_CLIENT.exec('FETCH 50 FROM streets_cursor')
      streets.each do |street|
        # load it up
        bar.progress += 1
        set = Pelias::LocationSet.new
        set.append_records 'osm_id', street['osm_id']
        set.close_records_for 'street'
        set.update do |_id, entry|
          entry['osm_id'] = sti street['osm_id']
          entry['name'] = entry['street_name'] = street['name']
          entry['center_point'] = JSON.parse(street['center'])['coordinates']
          entry['boundaries'] = JSON.parse(street['street'])
        end
        # and save
        set.grab_parents ['neighborhood', 'locality', 'admin2', 'local_admin']
        set.finalize!
      end
    end while streets.count > 0
    Pelias::PG_CLIENT.exec('CLOSE streets_cursor')
    Pelias::PG_CLIENT.exec('COMMIT')
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
            :center_point => center['coordinates']
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

  private

  def all_streets_count_sql
    'SELECT count(1) FROM planet_osm_line WHERE name IS NOT NULL AND highway IS NOT NULL'
  end

  def all_streets_sql
    "SELECT osm_id, name,
      ST_AsGeoJSON(ST_Transform(way, 4326), 6) AS street,
      ST_AsGeoJSON(ST_Transform(ST_LineInterpolatePoint(way, 0.5), 4326), 6) AS center
    FROM planet_osm_line
    WHERE name IS NOT NULL AND highway IS NOT NULL
    ORDER BY osm_id"
  end

end
