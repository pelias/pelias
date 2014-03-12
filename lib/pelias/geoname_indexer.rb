module Pelias
  class GeonameIndexer

    include Sidekiq::Worker

    # Update details for this geoname
    def perform(line)
      arr = line.chomp.split("\t")
      set = Pelias::LocationSet.new
      set.append_records 'gn_id', arr[0]
      set.update do |_id, entry|
        # Fill in our base details
        entry['name'] = arr[1]
        entry['alternate_names'] = arr[3].split(',')
        entry['population'] = arr[14].to_i
        # And propagate to others' payloads via location indexer
        type = entry['location_type']
        Pelias::LocationIndexer.perform_async({ "refs.#{type}" => _id }, nil, nil, {
          "#{type}_name" => arr[1],
          "#{type}_alternate_names" => arr[3].split(',')
        })
      end
      set.finalize!
    end

  end
end
