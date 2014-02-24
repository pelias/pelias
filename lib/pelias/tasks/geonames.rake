require 'pelias'
require 'redis'

namespace :geonames do

  TEMP_PATH = '/tmp/mapzen/geonames'

  # Download geonames data
  task :download do
    unless File.exist?("#{temp_path}/allCountries.txt")
      `wget http://download.geonames.org/export/dump/allCountries.zip -P #{temp_path}`
      `unzip #{temp_path}/allCountries.zip -d #{temp_path}`
    end
  end

  # Construct a cache of geoname hash data
  task :construct_cache => :download do
    File.open("#{temp_path}/allCountries.txt") do |f|
      f.each_line.with_index do |line, i|
        gn_id = line[0, line.index("\t")]
        key = "gn:#{gn_id}"
        Pelias::REDIS.set key, line
        print '.' if i % 1000 == 0
      end
    end
  end

  def do
    thing.each
      f.each_line.lazy.
        map { |l| l.chomp.split("\t") }.
        each do |d|

          next unless data[:country_code] == 'US'

          set = Pelias::LocationSet.new 'gn_id', arr[0]

          set.update do |entry|

            entry['country'] = entry['country'] || {}
            entry['country']['code'] = arr[8]

            entry['name'] = arr[1]
            entry['alternate_names'] = arr[3].split(',')
            entry['population'] = arr[14]

            entry[set.type]['name'] = arr[1]
            entry[set.type]['alternate_names'] = arr[3].split(',')

          end

          set.finalize!

        end
    puts
  end

  private

  # Format TSV array into proper format
  def format_geoname(arr)
    {
      :feature_class => arr[6],
      :feature_code => arr[7],
      :admin1_code => arr[10],
      :admin2_code => arr[11],
      :admin3_code => arr[12],
      :admin4_code => arr[13]
    }
  end

  def temp_path
    '/tmp/mapzen/quattroshapes'
  end

end
