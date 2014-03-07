require_relative 'task_helper'
require 'rgeo-shapefile'

namespace :quattroshapes do

  task :prepare_all => Pelias::LocationIndexer::PATHS.map { |t, _| "prepare_#{t}" }

  Pelias::LocationIndexer::PATHS.each do |type, file|
    task(:"prepare_#{type}") { perform_prepare(type, file) }
    task(:"populate_#{type}") { perform_index(type) }
  end

  task :populate_single do
    Pelias::LocationIndexer.perform_async ENV['LOCATION_TYPE'], ENV['LOCATION_IDX'].to_i
  end

  private

  # Download the things we need
  def perform_prepare(type, file)
    sh "wget http://static.quattroshapes.com/#{file}.zip -P #{TEMP_PATH}" # download
    sh "unzip #{TEMP_PATH}/#{file}.zip -d #{TEMP_PATH}" # expand
    sh "shp2pgsql -D -d -Nskip -I -WLATIN1 #{TEMP_PATH}/#{file}.shp qs.qs_#{type} > #{TEMP_PATH}/#{file}.sql" # convert
    sh "psql #{Pelias::PG_DBNAME} < #{TEMP_PATH}/#{file}.sql" # import
    sh "rm #{TEMP_PATH}/#{file}*" # clean up
  end

  # Perform an index
  def perform_index(type)
    results = Pelias::DB["SELECT COUNT(1) as count from qs.qs_#{type}"]
    count = results.first[:count].to_i
    bar = ProgressBar.create(total: count, format: '%e |%b>%i| %p%%')
    count.times do |idx|
      bar.progress += 1
      Pelias::LocationIndexer.perform_async type, idx
    end
  end

end
