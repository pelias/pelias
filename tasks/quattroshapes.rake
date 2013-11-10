require 'pelias'

namespace :quattroshapes do

  desc "populate neighborhood data"
  task :populate_neighborhoods do
    shp = "data/quattroshapes/neighborhoods/qs_neighborhoods.shp"
    RGeo::Shapefile::Reader.open(shp) do |file|
      file.each do |record|
        geometry = RGeo::GeoJSON.encode(record.geometry)
        geonames_id = record.attributes['gn_id'].to_i
        next if geonames_id == 0
        next unless geoname = Pelias::Base::ES_CLIENT.get(index: 'geonames',
          type: 'feature', id: geonames_id, ignore: 404)
        geoname = geoname['_source']
        # just testing this in ny for now
        next unless geoname['admin1_code'] == 'NY'
        begin
          Pelias::Base::ES_CLIENT.index(index: 'quattroshapes',
            type: 'neighborhood', id: geonames_id, 
            body: get_qs(geoname, geometry))
        rescue Elasticsearch::Transport::Transport::Errors::BadRequest
          puts "Bad polygon: #{geoname.inspect}"
        end
      end
    end
  end

  desc "populate locality data"
  task :populate_localities do
    shp = "data/quattroshapes/localities/gn-qs_localities.shp"
    RGeo::Shapefile::Reader.open(shp) do |file|
      file.each do |record|
        geometry = RGeo::GeoJSON.encode(record.geometry)
        geonames_id = record.attributes['gs_gn_id']
        next if geonames_id == ''
        geonames_id = geonames_id.split(',').first if geonames_id[',']
        next unless geoname = Pelias::Base::ES_CLIENT.get(index: 'geonames',
          type: 'feature', id: geonames_id, ignore: 404)
        geoname = geoname['_source']
        # just testing this in ny for now
        next unless geoname['admin1_code'] == 'NY'
        Pelias::Base::ES_CLIENT.index(index: 'quattroshapes',
          type: 'locality', id: geonames_id, body: get_qs(geoname, geometry))
      end
    end
  end

  def get_qs(geoname, geometry)
    {
      name: geoname['name'],
      alternate_names: geoname['alternate_names'],
      country_code: geoname['country_code'],
      admin1_code: geoname['admin1_code'],
      admin2_code: geoname['admin2_code'],
      admin3_code: geoname['admin3_code'],
      admin4_code: geoname['admin4_code'],
      population: geoname['population'],
      centerpoint: geoname['location'],
      boundaries: geometry
    }
  end

  desc "setup index & mappings"
  task :setup do
    schema_file = File.read('schemas/quattroshapes.json')
    schema_json = JSON.parse(schema_file)
    Pelias::Base::ES_CLIENT.indices.create(index: 'quattroshapes',
      body: schema_json)
  end

end
