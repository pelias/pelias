require_relative 'task_helper'
require 'promise'
require 'rgeo-shapefile'

namespace :quattroshapes do

  task :populate_admin1 do
    do_thing 'admin1', 'qs_adm1', 'qs_a1', []
  end

  task :populate_admin2 do
    do_thing 'admin2', 'qs_adm2', 'qs_a2', ['admin1']
  end

  task :populate_local_admin do
    do_thing 'local_admin', 'qs_localadmin', 'qs_la', ['admin1', 'admin2']
  end

  task :populate_locality do
    do_thing 'locality', 'qs_localities', 'qs_loc', ['admin1', 'admin2', 'local_admin']
  end

  task :populate_neighborhood do
    do_thing 'neighborhood', 'qs_neighborhoods', 'name', ['admin1', 'admin2', 'local_admin', 'locality']
  end

  private

  def do_thing(type, path, name_field, shape_types)
    download_shapefiles(path)
    path = "#{TEMP_PATH}/#{path}"
    RGeo::Shapefile::Reader.open(path) do |file|
      bar = ProgressBar.create(total: file.num_records, format: '%e |%b>%i| %p%%')
      file.each do |record|
        bar.progress += 1
        #next unless record.attributes['qs_iso_cc'] == 'US' || record.attributes['qs_adm0_a3'] == 'US' || record.attributes['gn_adm0_cc'] == 'US'
        #next unless record.attributes['qs_a1'] == 'New Jersey' || record.attributes['qs_a1'] == '*New Jersey' || record.attributes['name_adm1'] == 'New Jersey'
        next if record.geometry.nil?
        # make sure we have a geoname id
        gn_id = sti record.attributes['qs_gn_id'] || record.attributes['gn_id']
        woe_id = sti record.attributes['qs_woe_id'] || record.attributes['woe_id']
        # Update as geoname
        set = Pelias::LocationSet.new
        set.append_records "#{type}.gn_id", gn_id
        set.append_records "#{type}.woe_id", woe_id
        set.close_records_for type
        set.update do |_id, entry|

          entry['name'] = record.attributes[name_field]
          entry['gn_id'] = gn_id
          entry['woe_id'] = woe_id
          entry['boundaries'] = RGeo::GeoJSON.encode(record.geometry)
          entry['center_point'] = RGeo::GeoJSON.encode(record.geometry.centroid)['coordinates']
          entry["#{type}_name"] = entry['name']

          # other data
          entry['admin0_abbr'] = record.attributes['qs_iso_cc']
          entry['admin0_name'] = country_data[entry['admin0_abbr']].try(:[], :name)
          raise "admin name not found for #{entry['admin0_abbr']}" unless entry['admin0_name']

        end
        set.grab_parents shape_types
        set.finalize!
      end
    end
  end

  def country_data
    @country_data ||= YAML.load_file 'lib/pelias/data/geonames/countries.yml'
  end

  def download_shapefiles(file)
    unless File.exist?("#{TEMP_PATH}/#{file}.shp")
      sh "wget http://static.quattroshapes.com/#{file}.zip -P #{TEMP_PATH}"
      sh "unzip #{TEMP_PATH}/#{file}.zip -d #{TEMP_PATH}"
    end
  end

end
