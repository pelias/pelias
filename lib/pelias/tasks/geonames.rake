require 'pelias'

namespace :geonames do

  task :populate => :download do
    i = 0
    File.open("#{TEMP_PATH}/allCountries.txt") do |file|
      file.each_line do |line|
        i += 1
        puts "Prepared #{i}" if i % 10000 == 0
        Pelias::GeonameIndexer.perform_async line
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
