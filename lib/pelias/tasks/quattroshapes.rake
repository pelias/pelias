require_relative 'task_helper'
require 'rgeo-shapefile'

namespace :quattroshapes do

  task(:populate_admin0)       { perform_index 'admin0' }
  task(:populate_admin1)       { perform_index 'admin1' }
  task(:populate_admin2)       { perform_index 'admin2' }
  task(:populate_local_admin)  { perform_index 'local_admin' }
  task(:populate_locality)     { perform_index 'locality' }
  task(:populate_neighborhood) { perform_index 'neighborhood' }

  task :populate_single do
    Pelias::LocationIndexer.perform_async ENV['LOCATION_TYPE'], ENV['LOCATION_IDX'].to_i
  end

  # Download the things we need
  task :download do
    Pelias::LocationIndexer::PATHS.each do |type, file|
      unless File.exist?("#{TEMP_PATH}/#{file}.sql")

        # Download
        sh "wget http://static.quattroshapes.com/#{file}.zip -P #{TEMP_PATH}"

        # Unzip
        sh "unzip #{TEMP_PATH}/#{file}.zip -d #{TEMP_PATH}"

        # Convert for postgis
        sh "shp2pgsql -d #{TEMP_PATH}/#{file}.shp qs.qs_#{type} > #{TEMP_PATH}/#{file}.sql"

        # Import into postgis
        sh "psql #{Pelias::PG_DBNAME} < #{TEMP_PATH}/#{file}.sql"

      end
    end
  end

  private

  def perform_index(type)
    reader = RGeo::Shapefile::Reader.open("#{TEMP_PATH}/#{Pelias::LocationIndexer::PATHS[type.to_sym]}")
    bar = ProgressBar.create(total: reader.num_records, format: '%e |%b>%i| %p%%')
    reader.num_records.times do |idx|
      bar.progress += 1
      Pelias::LocationIndexer.perform_async type, idx
    end
  end

end
