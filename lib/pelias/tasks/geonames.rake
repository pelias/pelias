require 'pelias'
require 'ruby-progressbar'

namespace :geonames do

  task :populate => :download do
    File.open("#{temp_path}/allCountries.txt") do |file|
      bar = ProgressBar.create(total: 10_000_000, format: '%e |%b>%i| %p%%')
      file.each_line.with_index do |line, i|
        arr = line.chomp.split("\t")
        bar.progress += 1
        next unless arr[8] == 'US'
        next unless arr[10] == 'NJ'
        # Update details for this geoname
        set = Pelias::LocationSet.new
        set.append_records 'gn_id', arr[0]
        set.update do |entry|
          # Fill in our base details
          entry['name'] = arr[1]
          entry['alternate_names'] = arr[3].split(',')
          entry['population'] = arr[14].to_i
          # And propagate to others' payloads
          underset = Pelias::LocationSet.new
          underset.append_records "ref.#{entry['location_type']}", entry['_id']
          underset.update do |uentry|
            type = entry['location_type']
            uentry["#{type}_name"] = arr[1]
            uentry["#{type}_alternate_names"] = arr[3].split(',')
          end
          underset.finalize!
        end
        set.finalize!
      end
    end
  end

  task :download do
    unless File.exist?("#{temp_path}/allCountries.txt")
      `wget http://download.geonames.org/export/dump/allCountries.zip -P #{temp_path}`
      `unzip #{temp_path}/allCountries.zip -d #{temp_path}`
    end
  end

  private

  def temp_path
    '/tmp/mapzen/quattroshapes'
  end

end
