require 'pelias'
require 'ruby-progressbar'

namespace :geonames do

  task :populate => :download do
    File.open("#{TEMP_PATH}/allCountries.txt") do |file|
      bar = ProgressBar.create(total: 10_000_000, format: '%e |%b>%i| %p%%')
      file.each_line.with_index do |line, i|
        bar.progress += 1
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
