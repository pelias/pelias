require 'pelias'

namespace :geonames do

  task :prepare => :download do
    i = 0
    File.open("#{TEMP_PATH}/allCountries.txt").each do |line|
      puts "Inserted #{i}" if (i += 1) % 10_000 == 0
      arr = line.chomp.split("\t")
      begin
        Pelias::REDIS.hset('geoname', arr[0], {
          name: arr[1],
          alternate_names: arr[3].split(','),
          population: arr[14].to_i
        }.to_json)
      rescue Redis::TimeoutError
        retry
      end
    end
  end

  task :download do
    unless File.exist?("#{TEMP_PATH}/allCountries.txt")
      `wget http://download.geonames.org/export/dump/allCountries.zip -P #{TEMP_PATH}`
      `unzip #{TEMP_PATH}/allCountries.zip -d #{TEMP_PATH}`
    end
  end

end
