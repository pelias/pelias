require 'pelias'

namespace :quattroshapes do

  task :download do
    download_shapefiles('qs_neighborhoods')
    download_shapefiles('gn-qs_localities')
    download_shapefiles('qs_localadmin')
    download_shapefiles('qs_adm2')
  end

  task :populate_admin2 do
    keys = { id: 'qs_gn_id', name: 'qs_a2', cc: 'qs_iso_cc' }
    index_shapes(Pelias::Admin2, 'qs_adm2', keys)
  end

  task :populate_localities do
    keys = { id: 'qs_gn_id', name: 'qs_loc', cc: 'qs_adm0_a3' }
    index_shapes(Pelias::Locality, 'gn-qs_localities', keys)
  end

  task :populate_local_admin do
    keys = { id: 'qs_gn_id', name: 'qs_la', cc: 'qs_iso_cc' }
    index_shapes(Pelias::LocalAdmin, 'qs_localadmin', keys)
  end

  task :populate_neighborhoods do
    keys = { id: 'gn_id', name: 'name', cc: 'gn_adm0_cc' }
    index_shapes(Pelias::Neighborhood, 'qs_neighborhoods', keys)
  end

  private

  def index_shapes(klass, shp, keys)
    shp = "#{temp_path}/#{shp}"
    RGeo::Shapefile::Reader.open(shp) do |file|
      file.each do |record|
        next unless record.attributes[keys[:cc]] == 'US'
        next if record.geometry.nil?
        print '.'
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
          # and use it for the names too
          loc.name = geoname.name
          loc.alternate_names = geoname.alternate_names
        else
          # if not, get any geoname in the boundaries
          # but don't use the names because it won't make sense
          loc.center_shape = RGeo::GeoJSON.encode(record.geometry.centroid)
          loc.center_point = loc.center_shape['coordinates']
          next unless geoname = loc.closest_geoname
        end
        next unless geoname.country_code=='US'
        geoname_hash = geoname.to_hash
        # names already set above, don't use this one
        geoname_hash.delete('name')
        geoname_hash.delete('alternate_names')
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
            retry
          end
        end
      end
    end
  end

  def download_shapefiles(file)
    unless File.exist?("#{temp_path}/#{file}.shp")
      sh "wget http://static.quattroshapes.com/#{file}.zip -P #{temp_path}"
      sh "unzip #{temp_path}/#{file}.zip -d #{temp_path}"
    end
  end

  def temp_path
    '/tmp/mapzen/quattroshapes'
  end

end
