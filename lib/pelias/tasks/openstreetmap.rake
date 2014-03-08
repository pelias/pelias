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
        next unless osm_id = sti(street['osm_id'])
        set = Pelias::LocationSet.new
        set.append_records 'osm_id', osm_id
        set.close_records_for 'street'
        set.update do |_id, entry|
          entry['osm_id'] = osm_id
          entry['name'] = entry['street_name'] = street['name']
          entry['center_point'] = JSON.parse(street['center'])['coordinates']
          entry['boundaries'] = JSON.parse(street['street'])
        end
        # and save
        set.grab_parents ['neighborhood', 'locality', 'admin1', 'admin2', 'local_admin']
        set.finalize!
      end
    end while streets.count > 0
    Pelias::PG_CLIENT.exec('CLOSE streets_cursor')
    Pelias::PG_CLIENT.exec('COMMIT')
  end

  task :populate_address do
    %w(point polygon line).each do |shape|
      r = Pelias::DB[all_addresses_count_sql_for(shape)]
      bar = ProgressBar.create(total: r.first[:count].to_i, format: '%e |%b>%i| %p%%')
      Pelias::DB[all_addresses_sql_for(shape)].use_cursor.each do |address|
        bar.progress += 1
        next unless osm_id = sti(address[:osm_id])
        set = Pelias::LocationSet.new
        set.append_records 'osm_id', osm_id
        set.close_records_for 'address'
        set.update do |_id, entry|
          entry['osm_id'] = osm_id
          entry['name'] = entry['address_name'] = "#{address[:housenumber]} #{address[:street_name]}"
          entry['street_name'] = address[:street_name]
          entry['center_point'] = JSON.parse(address[:location])['coordinates']
          set.grab_parents [:neighborhood, :locality, :local_admin, :admin2, :admin1, :admin0], entry # TODO use central location
        end
        # and save
        set.finalize!
      end
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

  def all_addresses_count_sql_for(shape)
    "SELECT count(1) FROM planet_osm_#{shape} WHERE \"addr:housenumber\" IS NOT NULL AND \"addr:street\" IS NOT NULL"
  end

  def all_addresses_sql_for(shape)
    "SELECT osm_id,
      \"addr:street\" AS street_name,
      \"addr:housenumber\" AS housenumber,
      ST_AsGeoJSON(ST_Transform(ST_Centroid(way), 4326), 6) AS location
    FROM planet_osm_#{shape}
    WHERE \"addr:housenumber\" IS NOT NULL
      AND \"addr:street\" IS NOT NULL
    ORDER BY osm_id"
  end

end
