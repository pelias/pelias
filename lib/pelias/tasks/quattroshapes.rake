require 'pelias'

namespace :quattroshapes do

  task :download do
    download_shapefiles("qs_neighborhoods.zip")
    download_shapefiles("gn-qs_localities.zip")
    download_shapefiles("qs_localadmin.zip")
    download_shapefiles("qs_adm2.zip")
  end

  task :populate_admin2 do
    keys = { :id=>'qs_gn_id', :name=>'qs_a2', :cc=>'qs_iso_cc' }
    index_shapes(Pelias::Admin2, "qs_adm2", keys)
  end

  task :populate_localities do
    keys = { :id=>'qs_gn_id', :name=>'qs_loc', :cc=>'qs_adm0_a3' }
    index_shapes(Pelias::Locality, "gn-qs_localities", keys)
  end

  task :populate_local_admin do
    keys = { :id=>'qs_gn_id', :name=>'qs_la', :cc=>'qs_iso_cc' }
    index_shapes(Pelias::LocalAdmin, "qs_localadmin", keys)
  end

  task :populate_neighborhoods do
    keys = { :id=>'gn_id', :name=>'name', :cc=>'gn_adm0_cc' }
    index_shapes(Pelias::Neighborhood, "qs_neighborhoods", keys)
  end

  def index_shapes(klass, shp, keys)
    shp = "lib/pelias/data/quattroshapes/#{shp}"
    RGeo::Shapefile::Reader.open(shp) do |file|
      file.each do |record|
        next unless record.attributes[keys[:cc]] == 'US'
        next if record.geometry.nil?
        id = record.attributes[keys[:id]].to_i
        name = record.attributes[keys[:name]]
        name = name.split(' (').first if name
        boundaries = RGeo::GeoJSON.encode(record.geometry)
        loc = klass.new(
          :id => id,
          :name => name,
          :boundaries => boundaries
        )
        # if there's a geoname id in the concordance, use it
        if id != 0 && geoname = Pelias::Geoname.find(id)
          # and use it for the name too
          loc.name = geoname.name
        else
          # if not, get any geoname in the boundaries
          # but don't use the name because it won't make sense
          loc.center_shape = RGeo::GeoJSON.encode(record.geometry.centroid)
          loc.center_point = loc.center_shape['coordinates']
          geoname = loc.closest_geoname
          next if geoname.nil?
        end
        next unless geoname.country_code=='US'
        geoname_hash = geoname.to_hash
        # name already set above, don't use this one
        geoname_hash.delete('name')
        loc.update(geoname_hash)
        # save time by not re-writing shapes we've already written
        unless Pelias::ES_CLIENT.get(index: Pelias::INDEX, type: klass.type,
          id: loc.id, ignore: 404)
          loc.set_encompassing_shapes
          loc.set_admin_names
          begin
            klass.delay.create(loc.to_hash)
          rescue
            # backoff a bit
            sleep 20
            klass.delay.create(loc.to_hash)
          end
        end
      end
    end
  end

  def download_shapefiles(file)
    url = "http://static.quattroshapes.com/#{file}"
    puts "downloading #{url}"
    open("lib/pelias/data/quattroshapes/#{file}", 'wb') do |file|
      file << open(url).read
    end
    Zip::File::open("lib/pelias/data/quattroshapes/#{file}") do |zip|
      zip.each do |entry|
        name = entry.name.gsub('shp/', '')
        unzipped_file = "lib/pelias/data/quattroshapes/#{name}"
        FileUtils.rm(unzipped_file, :force => true)
        puts "extracting #{unzipped_file}"
        entry.extract(unzipped_file)
      end
    end
  end

end
