require_relative 'task_helper'
require 'rgeo-shapefile'

namespace :quattroshapes do

  task :populate_admin1 do
    do_thing 'admin1', 'qs_adm1', 'qs_a1', []
  end

  task :populate_admin2 do
    do_thing 'admin2'
  end

  task :populate_local_admin do
    do_thing 'local_admin', 'qs_localadmin', 'qs_la', ['admin1', 'admin2']
  end

  task :populate_locality do
    do_thing 'locality', 'qs_localities', 'qs_loc', ['admin1', 'admin2', 'local_admin']
  end

  task :populate_neighborhood do
    do_thing 'neighborhood'
  end

  # Download the things we need
  task :download do
    Pelias::LocationIndexer::PATHS.each do |type, file|
      unless File.exist?("#{TEMP_PATH}/#{file}.shp")
        sh "wget http://static.quattroshapes.com/#{file}.zip -P #{TEMP_PATH}"
        sh "unzip #{TEMP_PATH}/#{file}.zip -d #{TEMP_PATH}"
      end
    end
  end

  private

  def do_thing(type)
    reader = RGeo::Shapefile::Reader.open("#{TEMP_PATH}/#{Pelias::LocationIndexer::PATHS[type.to_sym]}")
    bar = ProgressBar.create(total: reader.num_records, format: '%e |%b>%i| %p%%')
    reader.num_records.times do |idx|
      bar.progress += 1
      Pelias::LocationIndexer.perform_async type, idx
    end
  end

end
