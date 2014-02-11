require 'pelias'

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
    index_shapes(Pelias::Neighborhood, 'qs_neighborhoods', {
      geoname_id: 'gn_id',
      woe_id: 'woe_id',
      name: 'name'
    })
  end

  private

  def index_shapes(klass, shp, keys)
    shp = "#{temp_path}/#{shp}"
    RGeo::Shapefile::Reader.open(shp) do |file|
      file.each do |record|
        next if record.geometry.nil?

        # Grab the name
        name = record.attributes[keys[:name]]
        name = name.split(' (').first if name

        # Construct the location
        boundaries = RGeo::GeoJSON.encode(record.geometry)
        loc = klass.new(
          geoname_id: record.attributes[keys[:geoname_id]].to_i,
          woe_id: record.attributes[keys[:woe_id]].to_i,
          name: name,
          boundaries: boundaries
        )

        loc.woe_id = nil if loc.woe_id == 0
        loc.geoname_id = nil if loc.geoname_id == 0

        # Set shape and point
        loc.center_shape = RGeo::GeoJSON.encode(record.geometry.centroid)
        loc.center_point = loc.center_shape['coordinates']

        # write the shape
        klass.create(loc.to_hash)
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
