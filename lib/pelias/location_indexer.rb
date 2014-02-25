require 'rgeo-shapefile'

module Pelias
  class LocationIndexer

    include Sidekiq::Worker

    PATHS = {
      admin2: 'qs_adm2'
    }

    NAME_FIELDS = {
      admin2: 'qs_a2'
    }

    CC_FIELDS = {
      admin2: 'qs_iso_cc'
    }

    SHAPE_TYPES = {
      admin2: ['admin1']
    }

    COUNTRY_DATA = YAML.load_file 'lib/pelias/data/geonames/countries.yml'

    READER_SEMAPHORE = Mutex.new
    READERS = Hash.new { |h, k| h[k] = [] }

    def perform(type, idx)

      type_sym = type.to_sym
      path = "/tmp/mapzen/#{PATHS[type_sym]}"
      reader = get_locked_reader(path)

      # Load up our record
      reader.seek_index(idx)
      record = reader.next

      # Make sure we care a valid record
      cc = record.attributes[CC_FIELDS[type_sym]]
      return if record.geometry.nil?
      raise "bad cc: #{cc} (#{cc.class.name})" unless COUNTRY_DATA[cc]

      # grab our ids
      gn_id = sti record.attributes['qs_gn_id'] || record.attributes['gn_id']
      woe_id = sti record.attributes['qs_woe_id'] || record.attributes['woe_id']

      # Build a set
      set = Pelias::LocationSet.new
      set.append_records "#{type}.gn_id", gn_id
      set.append_records "#{type}.woe_id", woe_id
      set.close_records_for type

      # Update it
      set.update do |_id, entry|

        entry['name'] = record.attributes[NAME_FIELDS[type_sym]]
        entry['gn_id'] = gn_id
        entry['woe_id'] = woe_id
        entry['boundaries'] = RGeo::GeoJSON.encode(record.geometry)
        entry['center_point'] = RGeo::GeoJSON.encode(record.geometry.centroid)['coordinates']
        entry["#{type}_name"] = entry['name']

        # other data
        entry['admin0_abbr'] = cc
        entry['admin0_name'] = COUNTRY_DATA[cc][:name]

      end

      # And save
      set.grab_parents SHAPE_TYPES[type_sym]
      set.finalize!

    ensure

      return_locked_reader path, reader

    end

    private

    def get_locked_reader(path)
      reader = nil
      READER_SEMAPHORE.synchronize { reader = READERS[path].shift }
      reader || RGeo::Shapefile::Reader.open(path)
    end

    def return_locked_reader(path, reader)
      READER_SEMAPHORE.synchronize { READERS[path] << reader }
    end

    def sti(n)
      n.to_i == 0 ? nil : n.to_i
    end

  end
end
