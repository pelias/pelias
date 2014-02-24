module Pelias

  class LocationSet

    TYPE = 'location'

    attr_reader :records

    def initialize
      @records = []
    end

    def update(&block)
      records.each do |record|
        yield record['_source'] ? record['_source'] : record
      end
    end

    def finalize!
      return if records.empty?
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

    def grab_parents(shape_types)
      return if shape_types.empty?
      update do |entry|
        hits = Pelias::Search.encompassing_shape(entry['center_point'], shape_types)
        hits.each do |hit|

          type = hit['_source']['location_type']

          entry['ref'] = entry['ref'] || {}
          entry['ref'][type] = hit['_id']

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
