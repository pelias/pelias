require 'pelias'
require 'ruby-progressbar'
require 'rgeo-shapefile'

MultiJson.use :yajl
Sidekiq::Logging.logger = nil

namespace :quattroshapes do

  task :populate_neighborhoods do
    do_thing 'qs_neighborhoods', 'neighborhood', 'name', ['locality', 'local_admin', 'admin2']
  end

  task :populate_localities do
    do_thing 'qs_localities', 'locality', 'qs_loc', ['local_admin', 'admin2']
  end

  task :populate_local_admin do
    do_thing 'qs_localadmin', 'local_admin', 'qs_la', ['admin2']
  end

  task :populate_admin2 do
    do_thing 'qs_adm2', 'admin2', 'qs_a2'
  end

  def do_thing(path, type, name_field, shape_types)
    download_shapefiles(path)
    path = "#{temp_path}/#{path}"

    RGeo::Shapefile::Reader.open(path) do |file|
      bar = ProgressBar.create(total: file.num_records, format: '%e |%b>%i| %p%%')
      file.to_enum.lazy.
        select { |record| !record.geometry.nil? }.
        each do |record|

          bar.progress += 1

          gn_id = sti record.attributes['qs_gn_id'] || record.attributes['gn_id']
          woe_id = sti record.attributes['qs_woe_id'] || record.attributes['woe_id']
          next unless gn_id

          # Update as geoname
          set = Pelias::LocationSet.new "#{type}.gn_id", gn_id, type

          # Update the neighborhood data we have
          set.update do |entry|

            entry[type] = entry[type] || {}
            entry[type]['name'] = record.attributes[name_field] # temporary data
            entry[type]['gn_id'] = gn_id
            entry[type]['woe_id'] = woe_id

            if entry['_type'] == type
              entry['boundaries'] = RGeo::GeoJSON.encode(record.geometry)
              entry['center_shape'] = RGeo::GeoJSON.encode(record.geometry.centroid)
              entry['center_point'] = entry['center_shape']['coordinates']
            end

          end

          # Grab encompassing parents and set them up
          set.grab_parents shape_types

          # Finalize the updates
          set.finalize!

        end
    end
  end

  private

  def sti(n)
    n.to_i == 0 ? nil : n.to_i
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
