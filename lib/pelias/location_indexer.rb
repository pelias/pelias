require 'rgeo-shapefile'
require 'rgeo-geojson'

module Pelias
  class LocationIndexer

    include Sidekiq::Worker

    PATHS = {
      admin0: 'qs_adm0',
      admin1: 'qs_adm1',
      admin2: 'qs_adm2',
      local_admin: 'qs_localadmin',
      locality: 'gn-qs_localities',
      neighborhood: 'qs_neighborhoods'
    }

    NAME_FIELDS = {
      admin0: 'qs_a0',
      admin1: 'qs_a1',
      admin2: 'qs_a2',
      local_admin: 'qs_la',
      locality: 'qs_loc',
      neighborhood: 'name'
    }

    SHAPE_ORDER = [:admin0, :admin1, :admin2, :local_admin, :locality, :neighborhood]

    def perform(type, idx)

      type_sym = type.to_sym
      include_boundaries = type_sym != :admin0 && type_sym != :admin1

      # Load up our record
      fields = 'ST_AsText(ST_Centroid(geom)) as st_centroid'
      if type_sym == :locality
        fields << ',gn_id,woe_id'
      else
        fields << ',qs_gn_id,qs_woe_id'
      end
      fields << ',ST_AsText(geom) as st_geom' if include_boundaries
      fields << ",#{NAME_FIELDS[type_sym]}"
      results = Pelias::PG_CLIENT.exec "SELECT #{fields} from qs.qs_#{type} LIMIT 1 OFFSET #{idx}"
      record = results.first

      # grab our ids
      gn_id = sti record['qs_gn_id'] || record['gn_id'] # TODO allow gn_id
      woe_id = sti record['qs_woe_id'] || record['woe_id'] # TODO allow woe_id

      # Build a set
      set = Pelias::LocationSet.new
      set.append_records "#{type}.gn_id", gn_id
      set.append_records "#{type}.woe_id", woe_id
      set.close_records_for type

      # Update it
      set.update do |_id, entry|

        entry['name'] = record[NAME_FIELDS[type_sym]]
        entry['gn_id'] = gn_id
        entry['woe_id'] = woe_id
        entry['boundaries'] = record['st_astext'] if include_boundaries
        entry['center_point'] = record['st_centroid']
        entry["#{type}_name"] = entry['name']

      end

      # And save
      parent_types = SHAPE_ORDER[0...SHAPE_ORDER.index(type_sym)]
      set.grab_parents parent_types
      set.finalize!

    end

    private

    def sti(n)
      n.to_i == 0 ? nil : n.to_i
    end

  end
end
