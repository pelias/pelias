require_relative 'task_helper'

namespace :osm do

  task :populate_pois do
    %w(point polygon line).each do |shape|
      Pelias::DB[all_poi_sql_for(shape)].use_cursor.each do |poi|
        next unless osm_id = str(street[:osm_id])
        hash = Pelias::Poi.create_hash(poi.stringify_keys, shape)
        Pelias::LocationIndexer.perform_async({ osm_id: osm_id }, :poi, :street, hash)
      end
    end
  end

  task :populate_street do
    i = 0
    Pelias::DB[all_streets_sql].use_cursor.each do |street|
      i += 1
      next unless osm_id = sti(street[:osm_id])
      next unless street[:highway] && street[:name]
      puts "Prepared #{i}" if i % 10000 == 0
      Pelias::LocationIndexer.perform_async({ osm_id: osm_id }, :street, :street, {
        osm_id: osm_id,
        name: street[:name],
        street_name: street[:name],
        center_point: JSON.parse(street[:center])['coordinates'],
        boundaries: JSON.parse(street[:street])
      })
    end
  end

  task :populate_address do
    %w(point polygon line).each do |shape|
      i = 0
      Pelias::DB[all_addresses_sql_for(shape)].use_cursor.each do |address|
        i += 1
        next unless osm_id = sti(address[:osm_id])
        puts "Prepared #{i}" if i % 10000 == 0
        name = "#{address[:housenumber]} #{address[:street_name]}"
        Pelias::LocationIndexer.perform_async({ osm_id: osm_id }, :address, :street, {
          osm_id: osm_id,
          name: name,
          address_name: name,
          street_name: address[:street_name],
          center_point: JSON.parse(address[:location])['coordinates']
        })
      end
    end
  end

  private

  def all_poi_sql_for(shape)
    osm_features = %w{
      aerialway aeroway amenity building craft cuisine historic
      landuse leisure man_made military natural office public_transport
      railway shop sport tourism waterway
    }
    "SELECT osm_id, name, phone, website,
       \"addr:street\" AS street_name,
       \"addr:housenumber\" AS housenumber,
       ST_AsGeoJSON(ST_Transform(ST_Centroid(way), 4326), 6) AS location,
       \"#{osm_features * '","'}\"
    FROM planet_osm_#{shape}
    WHERE name IS NOT NULL
      AND (\"#{osm_features * '" IS NOT NULL OR "'}\" IS NOT NULL)
    ORDER BY osm_id"
  end

  def all_streets_sql
    "SELECT osm_id, name, highway,
      ST_AsGeoJSON(ST_Transform(way, 4326), 6) AS street,
      ST_AsGeoJSON(ST_Transform(ST_LineInterpolatePoint(way, 0.5), 4326), 6) AS center
    FROM planet_osm_line
    WHERE osm_id != 0"
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
