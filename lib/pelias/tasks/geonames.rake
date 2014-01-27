require 'pelias'
require 'open-uri'

namespace :geonames do

  TEMP_PATH = '/tmp/mapzen/geonames'

  # Download geonames data
  task :download do
    unless File.exist?("#{TEMP_PATH}/allCountries.txt")
      `wget http://download.geonames.org/export/dump/allCountries.zip -P #{TEMP_PATH}`
      `unzip #{TEMP_PATH}/allCountries.zip -d #{TEMP_PATH}`
    end
  end

  desc 'Populate geonames data into index (in batches)'
  task :populate => :download do
    File.open("#{TEMP_PATH}/allCountries.txt") do |f|
      f.each_line.lazy.
        map { |l| l.chomp.split("\t") }.
        select { |arr| arr[8] == 'US' }.
        map { |arr| format_geoname(arr) }.
        each_slice(500) { |sl| print '.'; Pelias::Geoname.delay.create(sl) }
    end
    puts
  end

  # Format TSV array into proper format
  def format_geoname(arr)
    {
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

end
