require 'pelias'

namespace :geonames do

  desc "populate geonames features"
  task :populate_features do
    File.open('data/geonames/allCountries.txt') do |fp|
      fp.each_slice(100) do |lines|
        body = lines.map do |line|
          arr = line.chomp.split("\t")
          {
            index: {
              _id: arr[0],
              data: {
                name: arr[1],
                alternate_names: arr[3].split(','),
                location: { type: 'Point', coordinates: [arr[5],arr[4]] },
                feature_class: arr[6],
                feature_code: arr[7],
                country_code: arr[8],
                admin1_code: arr[10],
                admin2_code: arr[11],
                admin3_code: arr[12],
                admin4_code: arr[13],
                population: arr[14],
                elevation: arr[15]
              }
            }
          }
        end
        Pelias::ES_CLIENT.bulk(index: 'pelias', type: 'geoname', body: body)
      end
    end
  end

  desc "populate geonames admin index"
  task :populate_admin do
    index_countries
    index_admin1
    index_admin2
    index_feature_codes
  end

  def index_countries
    File.open('data/geonames/countryInfo.txt') do |fp|
      fp.each do |line|
        arr = line.chomp.split("\t")
        next unless arr && arr.count > 1 && arr[0] != '#ISO'
        id = arr[0]
        name = arr[4]
        area = arr[6]
        population = arr[7]
        continent = arr[8]
        Pelias::ES_CLIENT.index(index: 'geonames', type: 'country', id: id,
          body: {
            name: name,
            area: area,
            population: population,
            continent: continent
          }
        )
      end
    end
  end

  def index_admin1
    File.open('data/geonames/admin1CodesASCII.txt') do |fp|
      fp.each do |line|
        arr = line.chomp.split("\t")
        id = arr[0]
        name = arr[1]
        geonames_id = arr[3]
        Pelias::ES_CLIENT.index(index: 'geonames', type: 'admin1', id: id,
          body: {
            name: name,
            geonames_id: geonames_id
          }
        )
      end
    end
  end

  def index_admin2
    File.open('data/geonames/admin2Codes.txt') do |fp|
      fp.each do |line|
        arr = line.chomp.split("\t")
        id = arr[0]
        name = arr[1]
        geonames_id = arr[3]
        Pelias::ES_CLIENT.index(index: 'geonames', type: 'admin2', id: id,
          body: {
            name: name,
            geonames_id: geonames_id
          }
        )
      end
    end
  end

  def index_feature_codes
    File.open('data/geonames/featureCodes_en.txt') do |fp|
      fp.each do |line|
        arr = line.chomp.split("\t")
        id = arr[0]
        name = arr[1]
        description = arr[2]
        Pelias::ES_CLIENT.index(index: 'geonames', type: 'feature_code', id: id,
          body: {
            name: name,
            description: description
          }
        )
      end
    end
  end

end
