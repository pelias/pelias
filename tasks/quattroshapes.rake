require 'pelias'

namespace :quattroshapes do

  task :populate_gazetteer do
    shp = "data/quattroshapes/gazetteer/quattroshapes_gazetteer_gn_then_gp.shp"
    RGeo::Shapefile::Reader.open(shp) do |file|
      file.each do |record|
        id = record.attributes['gn_id'].to_i
        next if id == 0
        next unless geoname = Pelias::Geoname.find(id)
        center_point = RGeo::GeoJSON.encode(record.geometry)['coordinates']
        gaz = Pelias::Gazette.new(:id=>id, :center_point=>center_point)
        vars = geoname.instance_variables
        vars.delete(:@id)
        vars.delete(:@location)
        vars.each do |key|
          key = key.to_s.delete("@")
          m = "#{key}="
          gaz.send(m, geoname.send(key)) if gaz.respond_to?(m)
        end
        gaz.set_admin_names
        gaz.save
      end
    end
  end

  task :populate_neighborhoods do
    shp = "data/quattroshapes/neighborhoods/qs_neighborhoods.shp"
    RGeo::Shapefile::Reader.open(shp) do |file|
      file.each do |record|
        geometry = RGeo::GeoJSON.encode(record.geometry)
        id = record.attributes['gn_id'].to_i
        next if id == 0
        next unless geoname = Pelias::Geoname.find(id)
        begin
          nabe = Pelias::Neighborhood.new(:id=>id, :boundaries=>geometry)
          vars = geoname.instance_variables
          vars.delete(:@id)
          vars.each do |key|
            key = key.to_s.delete("@")
            m = "#{key}="
            nabe.send(m, geoname.send(key)) if nabe.respond_to?(m)
          end
          nabe.set_admin_names
          nabe.save
        rescue Elasticsearch::Transport::Transport::Errors::BadRequest
          puts "BAD GEOMETRY: #{geoname.inspect}"
        end
      end
    end
  end

  task :populate_localities do
    shp = "data/quattroshapes/localities/gn-qs_localities.shp"
    RGeo::Shapefile::Reader.open(shp) do |file|
      file.each do |record|
        geometry = RGeo::GeoJSON.encode(record.geometry)
        id = record.attributes['gs_gn_id'].to_i
        next if id == 0
        next unless geoname = Pelias::Geoname.find(id)
        loc = Pelias::Locality.new(:id=>id, :boundaries=>geometry)
        vars = geoname.instance_variables
        vars.delete(:@id)
        vars.each do |key|
          key = key.to_s.delete("@")
          m = "#{key}="
          loc.send(m, geoname.send(key)) if loc.respond_to?(m)
        end
        loc.set_admin_names
        begin
          loc.save
        rescue
          # large polygons time out on request but still index
          puts "CHECK #{loc.id}: #{loc.name}"
        end
      end
    end
  end

  task :populate_local_admin do
    shp = "data/quattroshapes/local_admin/qs_localadmin.shp"
    RGeo::Shapefile::Reader.open(shp) do |file|
      file.each do |record|
        id = record.attributes['gs_gn_id'].to_i
        next if id == 0
        next unless geoname = Pelias::Geoname.find(id)
        boundaries = RGeo::GeoJSON.encode(record.geometry)
        loc = Pelias::LocalAdmin.new(:id=>id, :boundaries=>boundaries)
        vars = geoname.instance_variables
        vars.delete(:@id)
        vars.each do |key|
          key = key.to_s.delete("@")
          m = "#{key}="
          loc.send(m, geoname.send(key)) if loc.respond_to?(m)
        end
        loc.set_admin_names
        begin
          loc.save
        rescue
          # large polygons time out on request but still index
          puts "CHECK #{loc.id}: #{loc.name}"
        end
      end
    end
  end

end
