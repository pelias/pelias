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
      admin0: :qs_a0,
      admin1: :qs_a1,
      admin2: :qs_a2,
      local_admin: :qs_la,
      locality: :qs_loc,
      neighborhood: :name
    }

    SHAPE_ORDER = [:admin0, :admin1, :admin2, :local_admin, :locality, :neighborhood, :street, :address]

    def perform(type, gid)

      type_sym = type.to_sym
      include_boundaries = type_sym != :admin0 && type_sym != :admin1

      # Load up our record
      fields = 'ST_AsText(ST_Centroid(geom)) as st_centroid'
      if type_sym == :neighborhood
        fields << ',gn_id,woe_id'
      else
        fields << ',qs_gn_id,qs_woe_id'
      end
      fields << ',ST_AsGeoJson(geom) as st_geom' if include_boundaries
      fields << ",#{NAME_FIELDS[type_sym]}"
      results = Pelias::DB["SELECT #{fields} from qs.qs_#{type} WHERE gid=#{gid}"]
      record = results.first

      # grab our ids
      gn_id = sti record[:qs_gn_id] || record[:gn_id]
      woe_id = sti record[:qs_woe_id] || record[:woe_id]

      # Build a set
      set = Pelias::LocationSet.new
      set.append_records "#{type}.gn_id", gn_id
      set.append_records "#{type}.woe_id", woe_id
      set.close_records_for type

      # Update it
      parent_types = LocationIndexer.parent_types_for(type_sym)
      set.update do |_id, entry|

        entry['name'] = record[NAME_FIELDS[type_sym]]
        entry['gn_id'] = gn_id
        entry['woe_id'] = woe_id
        entry['boundaries'] = JSON.parse(record[:st_geom]) if include_boundaries
        entry['center_point'] = record[:st_centroid]
        entry["#{type}_name"] = entry['name']

        set.grab_parents(parent_types, entry)

        entry['center_point'] = parse_point record[:st_centroid]

      end

      # And save
      set.finalize!

    end

    private

    # convert a point to es format
    def parse_point(point_data)
      point_data.gsub(/[^\d\. ]/, '').split(' ').map(&:to_f)
    end

    def sti(n)
      if n
        n_i = n.to_i
        n_i if n_i > 0
      end
    end

    def self.parent_types_for(type)
      SHAPE_ORDER[0...SHAPE_ORDER.index(type)]
    end

  end
end
