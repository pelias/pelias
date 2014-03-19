require 'pelias'

namespace :geonames do

  task :populate => :download do
    i = 0
    File.open("#{TEMP_PATH}/allCountries.txt").lazy.each_slice(1000) do |lines|
      puts "Prepared #{i}" if (i += 1_000) % 100_000 == 0
      Pelias::GeonameIndexer.perform_async lines
    end
  end

  task :download do
    unless File.exist?("#{TEMP_PATH}/allCountries.txt")
      `wget http://download.geonames.org/export/dump/allCountries.zip -P #{TEMP_PATH}`
      `unzip #{TEMP_PATH}/allCountries.zip -d #{TEMP_PATH}`
    end
  end

end
