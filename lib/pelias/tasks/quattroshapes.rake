require 'pelias'
require 'ruby-progressbar'
require 'rgeo-shapefile'
require_relative '../../../neighborhood_transform'

MultiJson.use :yajl
Sidekiq::Logging.logger = nil

namespace :quattroshapes do

  task :populate_admin2 do
    download_shapefiles('qs_adm2')
    index_shapes(Pelias::Admin2, 'qs_adm2', {
      geoname_id: 'qs_gn_id',
      woe_id: 'qs_woe_id',
      name: 'qs_a2'
    })
  end

  task :populate_localities do
    download_shapefiles('gn-qs_localities')
    index_shapes(Pelias::Locality, 'gn-qs_localities', {
      geoname_id: 'qs_gn_id',
      woe_id: 'qs_woe_id',
      name: 'qs_loc'
    })
  end

  task :populate_local_admin do
    download_shapefiles('qs_localadmin')
    index_shapes(Pelias::LocalAdmin, 'qs_localadmin', {
      geoname_id: 'qs_gn_id',
      woe_id: 'qs_woe_id',
      name: 'qs_la'
    })
  end

  task :populate_neighborhoods do
    download_shapefiles('qs_neighborhoods')
    index_shapes('qs_neighborhoods') do |record|
      qs_neighborhood_transform(record).tap { |h| puts h.inspect }
    end
  end

  private

  def index_shapes(shp)
    shp = "#{temp_path}/#{shp}"
    RGeo::Shapefile::Reader.open(shp) do |file|
      bar = ProgressBar.create(total: file.num_records, format: '%e |%b>%i| %p%%')
      file.to_enum.lazy.
        select { |record| !record.geometry.nil? }.
        map { |record| yield(record) }.compact.
        each_slice(50) { |slice| bar.progress += slice.count; Pelias::Location.create(slice) }
      bar.finish
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
