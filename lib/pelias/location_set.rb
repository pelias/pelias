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
        denied = ['boundaries', 'suggest']
        entry['suggest']['payload'] = entry.reject { |k, v| denied.include?(k) }
      end
    end

    def finalize!
      return if records.empty?
      rebuild_suggestions!
      bulk = []
      records.each do |record|
        if record['_source']
          bulk << { index: { _id: record.delete('_id'), data: record['_source'] } }
        else
          bulk << { index: { data: record } }
        end
      end
      ES_CLIENT.bulk(index: Pelias::INDEX, type: 'location', body: bulk)
    end

    def grab_parents(shape_types, entry)
      shape_types.each do |type|
        name_field = LocationIndexer::NAME_FIELDS[type]
        query = "SELECT #{name_field} FROM qs.qs_#{type} WHERE ST_Contains(geom, ST_GeometryFromText('#{entry['center_point']}'))";
        if result = Pelias::DB[query].first
          entry["#{type}_name"] = result[name_field]
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
