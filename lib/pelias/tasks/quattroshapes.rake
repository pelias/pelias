require_relative 'task_helper'
require 'rgeo-shapefile'

namespace :quattroshapes do

  task(:populate_admin1)       { perform_index 'admin1' }
  task(:populate_admin2)       { perform_index 'admin2' }
  task(:populate_local_admin)  { perform_index 'local_admin' }
  task(:populate_locality)     { perform_index 'locality' }
  task(:populate_neighborhood) { perform_index 'neighborhood' }

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

  def perform_index(type)
    reader = RGeo::Shapefile::Reader.open("#{TEMP_PATH}/#{Pelias::LocationIndexer::PATHS[type.to_sym]}")
    bar = ProgressBar.create(total: reader.num_records, format: '%e |%b>%i| %p%%')
    reader.num_records.times do |idx|
      bar.progress += 1
      Pelias::LocationIndexer.perform_async type, idx
    end
  end

end
