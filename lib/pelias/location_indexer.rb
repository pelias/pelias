module Pelias

  class LocationIndexer

    include Sidekiq::Worker

    def perform(record_sets, close_type, grab_parents_of, update_data)

      # Load records
      set = Pelias::LocationSet.new
      record_sets.each { |k, v| set.append_records(k, v) }
      set.close_records_for close_type if close_type

      # Update data
      set.update do |_id, entry|
        entry.merge!(update_data)
        if grab_parents_of
          set.grab_parents Pelias::QuattroIndexer.parent_types_for(grab_parents_of.to_sym), entry
        end
      end

      # And finalize
      set.finalize!

    end

  end

end
