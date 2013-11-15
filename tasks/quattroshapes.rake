require 'pelias'

namespace :quattroshapes do

  task :populate_gazetteer do
    shp = "data/quattroshapes/gazetteer/quattroshapes_gazetteer_gn_then_gp.shp"
    RGeo::Shapefile::Reader.open(shp) do |file|
      file.each do |record|
        location = RGeo::GeoJSON.encode(record.geometry)
        id = record.attributes['gn_id'].to_i
        next if id == 0
        next unless geoname = Pelias::Geoname.find(id)
        puts geoname.inspect
        # TODO this
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
        loc.save
      end
    end
  end

end
