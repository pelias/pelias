require 'bundler/setup'
require 'pelias'
require 'promise'
require 'ruby-progressbar'
require 'rgeo-shapefile'

MultiJson.use :yajl
Sidekiq::Logging.logger = nil

namespace :quattroshapes do

  task :populate_admin2 do
    do_thing 'admin2', 'qs_adm2', 'qs_a2', []
  end

  task :populate_local_admin do
    do_thing 'local_admin', 'qs_localadmin', 'qs_la', ['admin2']
  end

  task :populate_locality do
    do_thing 'locality', 'qs_localities', 'qs_loc', ['admin2', 'local_admin']
  end

  task :populate_neighborhood do
    do_thing 'neighborhood', 'qs_neighborhoods', 'name', ['locality', 'admin2', 'local_admin']
  end

  private

  def do_thing(type, path, name_field, shape_types)
    download_shapefiles(path)
    path = "#{temp_path}/#{path}"
    RGeo::Shapefile::Reader.open(path) do |file|
      bar = ProgressBar.create(total: file.num_records, format: '%e |%b>%i| %p%%')
      file.each do |record|
        bar.progress += 1
        next unless record.attributes['qs_iso_cc'] == 'US' ||
                    record.attributes['qs_adm0_a3'] == 'US' ||
                    record.attributes['gn_adm0_cc'] == 'US'
        next unless record.attributes['qs_a1'] == 'New Jersey' ||
                    record.attributes['qs_a1'] == '*New Jersey' ||
                    record.attributes['name_adm1'] == 'New Jersey'
        next if record.geometry.nil?
        # make sure we have a geoname id
        gn_id = sti record.attributes['qs_gn_id'] || record.attributes['gn_id']
        woe_id = sti record.attributes['qs_woe_id'] || record.attributes['woe_id']
        # Update as geoname
        set = Pelias::LocationSet.new type
        set.append_records "#{type}.gn_id", gn_id
        set.append_records "#{type}.woe_id", woe_id
        set.close_records
        set.update do |entry|

          entry['name'] = record.attributes[name_field]
          entry['gn_id'] = gn_id
          entry['woe_id'] = woe_id
          entry['boundaries'] = RGeo::GeoJSON.encode(record.geometry)
          entry['center_shape'] = RGeo::GeoJSON.encode(record.geometry.centroid)
          entry['center_point'] = entry['center_shape']['coordinates']

        end
        set.grab_parents shape_types
        set.finalize!
      end
    end
  end

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
