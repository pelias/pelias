require 'pelias'

namespace :quattroshapes do

  task :download do
    download_shapefiles("qs_neighborhoods.zip")
    download_shapefiles("gn-qs_localities.zip")
    download_shapefiles("qs_localadmin.zip")
  end

  task :populate_localities do
    index_shapes(Pelias::Locality, "gn-qs_localities.shp")
  end

  task :reindex_localities do
    results = Pelias::ES_CLIENT.search(index: 'pelias',
      type: 'locality', scroll: '10m', fields: 'id',
      body: { query: { match_all: {} }, sort: '_id' })
      i=0
      results['hits']['hits'].each do |h|
      i += 1
      puts "#{i}: #{h['_id']}"
        Pelias::Locality.find(h['_id']).reindex
      end
    begin
      results = Pelias::ES_CLIENT.scroll(scroll: '10m',
        scroll_id: results['_scroll_id'])
      results['hits']['hits'].each do |h|
      i += 1
      puts "#{i}: #{h['_id']}"
        Pelias::Locality.find(h['_id']).reindex
      end
    end while results['hits']['hits'].count > 0
  end

  task :populate_local_admin do
    index_shapes(Pelias::LocalAdmin, "qs_localadmin.shp")
  end

  task :reindex_local_admin do
    results = Pelias::ES_CLIENT.search(index: 'pelias',
      type: 'local_admin', scroll: '10m', fields: 'id',
      body: { query: { match_all: {} }, sort: '_id' })
      i=0
      results['hits']['hits'].each do |h|
        i += 1
        puts "#{i}: #{h['_id']}"
        Pelias::LocalAdmin.find(h['_id']).reindex
      end
    begin
      results = Pelias::ES_CLIENT.scroll(scroll: '10m',
        scroll_id: results['_scroll_id'])
      results['hits']['hits'].each do |h|
        i += 1
        puts "#{i}: #{h['_id']}"
        Pelias::LocalAdmin.find(h['_id']).reindex
      end
    end while results['hits']['hits'].count > 0
  end

  task :populate_neighborhoods do
    index_shapes(Pelias::Neighborhood, "qs_neighborhoods.shp")
  end

  task :reindex_neighborhoods do
    results = Pelias::ES_CLIENT.search(index: 'pelias',
      type: 'neighborhood', scroll: '10m', fields: 'id',
      body: { query: { match_all: {} }, sort: '_id' })
      i=0
      results['hits']['hits'].each do |h|
        i += 1
        puts "#{i}: #{h['_id']}"
        Pelias::Neighborhood.find(h['_id']).reindex
      end
    begin
      results = Pelias::ES_CLIENT.scroll(scroll: '10m',
        scroll_id: results['_scroll_id'])
      results['hits']['hits'].each do |h|
        i += 1
        puts "#{i}: #{h['_id']}"
        Pelias::Neighborhood.find(h['_id']).reindex
      end
    end while results['hits']['hits'].count > 0
  end

  def index_shapes(klass, shp)
    shp = "data/quattroshapes/#{shp}"
    RGeo::Shapefile::Reader.open(shp) do |file|
      file.each do |record|
        next unless record.attributes['qs_iso_cc']=='US' ||
          record.attributes['qs_adm0_a3']=='US'||
          record.attributes['gn_adm0_cc']=='US'
        if record.geometry.nil?
          puts "NIL GEOMETRY: #{record.attributes.inspect}"
          next
        end
        id = (record.attributes['gs_gn_id']||record.attributes['gn_id']).to_i
        boundaries = RGeo::GeoJSON.encode(record.geometry)
        name = record.attributes['qs_loc'] || record.attributes['qs_la']
        name = name.split(' (').first if name
        loc = klass.new(
          :id => id,
          :name => name,
          :boundaries => boundaries
        )
        # if there's a geoname id in the concordance, use it
        if geoname = Pelias::Geoname.find(id)
          # and use it for the name too
          loc.name = geoname.name
        else
          # if not, get any geoname in the boundaries
          # but don't use the name because it won't make sense
          loc.center_shape = RGeo::GeoJSON.encode(record.geometry.centroid)
          loc.center_point = loc.center_shape['coordinates']
          geoname = loc.closest_geoname
          next if geoname.nil?
        end
        next unless geoname.country_code=='US'
        geoname_hash = geoname.to_hash
        # name already set above, don't use this one
        geoname_hash.delete('name')
        loc.update(geoname_hash)
        # save time by not re-writing shapes we've already written
puts loc.id
        unless Pelias::ES_CLIENT.get(index: 'pelias', type: klass.type,
          id: loc.id, ignore: 404)
          loc.set_encompassing_shapes
          loc.set_admin_names
          klass.delay.create(loc.to_hash)
        end
      end
    end
  end

  def download_shapefiles(file)
    url = "http://static.quattroshapes.com/#{file}"
    puts "downloading #{url}"
    open("data/quattroshapes/#{file}", 'wb') do |file|
      file << open(url).read
    end
    Zip::File::open("data/quattroshapes/#{file}") do |zip|
      zip.each do |entry|
        name = entry.name.gsub('shp/', '')
        unzipped_file = "data/quattroshapes/#{name}"
        FileUtils.rm(unzipped_file, :force => true)
        puts "extracting #{unzipped_file}"
        entry.extract(unzipped_file)
      end
    end
  end

end
