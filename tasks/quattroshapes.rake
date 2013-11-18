require 'pelias'

namespace :quattroshapes do

  task :populate_gazetteer do
    cnt = 0
    bulk = []
    shp = "data/quattroshapes/gazetteer/quattroshapes_gazetteer_gn_then_gp.shp"
    RGeo::Shapefile::Reader.open(shp) do |file|
      file.each do |record|
        id = record.attributes['gn_id'].to_i
        next if id == 0
        next unless geoname = Pelias::Geoname.find(id)
        center_point = RGeo::GeoJSON.encode(record.geometry)['coordinates']
        attrs = {
          :id => id,
          :center_point => center_point
        }
        geoname = geoname.to_hash
        geoname.delete('id')
        geoname.delete('center_point')
        bulk << attrs.merge(geoname)
        if bulk.count >= 500
          Pelias::Gazette.create(bulk)
          bulk = []
        end
      end
    end
    if bulk.count > 0
      Pelias::Gazette.create(bulk)
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
        next unless boundaries = RGeo::GeoJSON.encode(record.geometry)
        center_shape = RGeo::GeoJSON.encode(boundaries.centroid)
        name = record.attributes['qs_la'].split(' (').first
        loc = Pelias::LocalAdmin.new(
          :name => name,
          :center_point => center_shape['coordinates'],
          :center_shape => center_shape,
          :boundaries => boundaries
        )
        if geoname = loc.closest_geoname
          puts "#{record.attributes['qs_iso_cc']} - #{name} - #{geoname['_source']['name']}"
          loc.update(
            :id => geoname['_id'],
            :feature_class => geoname['_source']['feature_class'],
            :feature_code => geoname['_source']['feature_code'],
            :country_code => geoname['_source']['country_code'],
            :admin1_code => geoname['_source']['admin1_code'],
            :admin2_code => geoname['_source']['admin2_code'],
            :admin3_code => geoname['_source']['admin3_code'],
            :admin4_code => geoname['_source']['admin4_code'],
            :population => geoname['_source']['population']
          )
          loc.save
        end
      end
    end
  end

end
