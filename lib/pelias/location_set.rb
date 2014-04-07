module Pelias

  class LocationSet

    TYPE = 'location'

    attr_reader :records

    def initialize
      @records = []
    end

    def update(&block)
      records.each do |record|
        yield record['_id'], record['_source'] ? record['_source'] : record
      end
    end

    def rebuild_suggestions!
      update do |_id, entry|
        suggest = Suggestion.send :"rebuild_suggestions_for_#{entry['location_type']}", Hashie::Mash.new(entry)
        entry['suggest'] = suggest
        denied = ['boundaries', 'suggest', 'refs']
        entry['suggest'][:input].compact!
        entry['suggest'][:input].uniq!
        entry['suggest']['payload'] = entry.reject { |k, v| denied.include?(k) }
      end
    end

    def finalize!
      return if records.empty?
      rebuild_suggestions!
      records.each_slice(100) do |slice|
        bulk = []
        slice.each do |record|
          if record['_source']
            bulk << { index: { _id: record.delete('_id'), data: record['_source'] } }
          else
            bulk << { index: { _id: record.delete('_id'), data: record } }
          end
        end
        r = ES_CLIENT.bulk(index: Pelias::INDEX, type: 'location', body: bulk)
        raise r.inspect if r['errors']
      end
    end

    def grab_parents(shape_types, entry)
      shape_types.each do |type|

        loc = "POINT(#{entry['center_point'][0]} #{entry['center_point'][1]})"
        query = "SELECT gid FROM qs_#{type} WHERE ST_Contains(geom, ST_GeometryFromText('#{loc}'))";
        result = Pelias::DB[query].first

        # Copy down data from the found record
        if result

          begin
            record = Pelias::ES_CLIENT.get(id: "qs:#{type}:#{result[:gid]}", type: 'location', index: Pelias::INDEX)
            source = record['_source']

            entry['refs'] ||= {}
            entry['refs'][type] = record['_id']
            entry["#{type}_name"] = source['name']
            entry["#{type}_abbr"] = source['abbr']
            entry["#{type}_alternate_names"] = source['alternate_names']
          rescue
            Pelias::QuattroIndexer.new.perform type, result[:gid]
            Pelias::ES_CLIENT.indices.refresh(index: Pelias::INDEX)
            retry
          end

        end

      end
    end

    def append_records(field, id)
      return unless id
      t = { field => id }
      results = ES_CLIENT.search(index: Pelias::INDEX, type: TYPE, body: { query: { term: t } })
      records.concat results['hits']['hits']
    end

    def close_records_for(type)
      if records.none? { |h| h['_source']['location_type'] == type }
        records << { 'location_type' => type } # Create a new record
      end
    end

  end

end
