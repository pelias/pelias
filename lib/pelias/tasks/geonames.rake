require 'pelias'
require 'ruby-progressbar'

namespace :geonames do

  task :populate => :download do
    File.open("#{TEMP_PATH}/allCountries.txt") do |file|
      bar = ProgressBar.create(total: 10_000_000, format: '%e |%b>%i| %p%%')
      file.each_line.with_index do |line, i|
        arr = line.chomp.split("\t")
        bar.progress += 1
        # Update details for this geoname
        set = Pelias::LocationSet.new
        set.append_records 'gn_id', arr[0]
        set.update do |_id, entry|
          # Fill in our base details
          entry['name'] = arr[1]
          entry['alternate_names'] = arr[3].split(',')
          entry['population'] = arr[14].to_i
          # And propagate to others' payloads
          type = entry['location_type']
          underset = Pelias::LocationSet.new
          underset.append_records "ref.#{type}", _id
          underset.update do |_uid, uentry|
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
    unless File.exist?("#{TEMP_PATH}/allCountries.txt")
      `wget http://download.geonames.org/export/dump/allCountries.zip -P #{TEMP_PATH}`
      `unzip #{TEMP_PATH}/allCountries.zip -d #{TEMP_PATH}`
    end
  end

end
