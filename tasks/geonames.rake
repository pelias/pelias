require 'pelias'
require 'open-uri'

namespace :geonames do

  task :download do
    url = 'http://download.geonames.org/export/dump/allCountries.zip'
    puts "downloading #{url}"
    open('data/geonames/allCountries.zip', 'wb') do |file|
      file << open(url).read
    end
    Zip::File::open("data/geonames/allCountries.zip") do |zip|
      zip.each do |entry|
        unzipped_file = "data/geonames/#{entry.name}"
        FileUtils.rm(unzipped_file, :force => true)
        puts "extracting #{unzipped_file}"
        entry.extract(unzipped_file)
      end
    end
  end

  task :populate do
    File.open('data/geonames/allCountries.txt') do |fp|
      fp.each_slice(1000) do |lines|
        bulk = []
        lines.each do |line|
          arr = line.chomp.split("\t")
          bulk << {
            :id => arr[0],
            :name => arr[1],
            :alternate_names => arr[3].split(','),
            :center_point => [arr[5].to_f, arr[4].to_f],
            :center_shape => {
              type: 'Point',
              coordinates: [arr[5].to_f, arr[4].to_f]
            },
            :feature_class => arr[6],
            :feature_code => arr[7],
            :country_code => arr[8],
            :admin1_code => arr[10],
            :admin2_code => arr[11],
            :admin3_code => arr[12],
            :admin4_code => arr[13],
            :population => arr[14],
            :elevation => arr[15]
          }
        end
        Pelias::Geoname.create(bulk)
      end
    end
  end

  task :yamlize_admin do
    # these yml files are in git, keeping around for updates
    yamlize_countries
    yamlize_admin1
    yamlize_admin2
    yamlize_feature_codes
  end

  def yamlize_countries
    countries = {}
    File.open('data/geonames/countryInfo.txt') do |fp|
      fp.each do |line|
        arr = line.chomp.split("\t")
        next unless arr && arr.count > 1 && arr[0] != '#ISO'
        countries[arr[0]] = {
          :name => arr[4],
          :area => arr[6],
          :population => arr[7],
          :continent => arr[8]
        }
      end
    end
    File.open('data/geonames/countries.yml', 'w') do |file|
      file.write(countries.to_yaml)
    end
  end

  def yamlize_admin1
    admin1 = {}
    File.open('data/geonames/admin1CodesASCII.txt') do |fp|
      fp.each do |line|
        arr = line.chomp.split("\t")
        admin1[arr[0]] = {
          :name => arr[1],
          :geonames_id => arr[3]
        }
      end
    end
    File.open('data/geonames/admin1.yml', 'w') do |file|
      file.write(admin1.to_yaml)
    end
  end

  def yamlize_admin2
    admin2 = {}
    File.open('data/geonames/admin2Codes.txt') do |fp|
      fp.each do |line|
        arr = line.chomp.split("\t")
        admin2[arr[0]] = {
          :name => arr[1],
          :geonames_id => arr[3]
        }
      end
    end
    File.open('data/geonames/admin2.yml', 'w') do |file|
      file.write(admin2.to_yaml)
    end
  end

  def yamlize_feature_codes
    feature_codes = {}
    File.open('data/geonames/featureCodes_en.txt') do |fp|
      fp.each do |line|
        arr = line.chomp.split("\t")
        feature_codes[arr[0]] = {
          :name => arr[1],
          :description => arr[2]
        }
      end
    end
    File.open('data/geonames/feature_codes.yml', 'w') do |file|
      file.write(feature_codes.to_yaml)
    end
  end

end
