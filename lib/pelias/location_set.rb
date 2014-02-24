module Pelias

  class LocationSet

    def initialize(field, id, type = nil)
      @field = field
      @id = id
      @type = type # create new record if not matching
    end

    def update(&block)
      records.each do |record|
        yield record['_source'] ? record['_source'] : record
      end
    end

    def finalize!
      return if records.empty? # lookup not found
      bulk = []
      records.each do |record|
        if record['_source']
          bulk << { index: { _id: record.delete('_id'), data: record['_source'] } }
        else
          bulk << { index: { data: record } }
        end
      end
      ES_CLIENT.bulk(index: Pelias::INDEX, type: @type, body: bulk)
    end

    def grab_parents(shape_types)
      return if shape_types.empty?
      update do |entry|
        puts entry['center_shape']
        hits = Pelias::Search.encompassing_shapes(entry['center_shape'], shape_types)
        hits.each do |hit|
          type = hit['type']
          entry[type] = entry[type] || {}
          entry[type]['name'] = hit[type]['name']
          entry[type]['gn_id'] = hit[type]['gn_id']
          entry[type]['woe_id'] = hit[type]['woe_id']
        end
      end
    end

    private

    def records
      @records ||= load_records
    end

    def load_records
      t = {}
      t[@field] = @id
      results = ES_CLIENT.search(index: Pelias::INDEX, type: @type, body: {
        query: { term: t }
      })
      results['hits']['hits'].tap do |arr|
        if arr.none? { |h| h['type'] == @type }
          arr << { '_type' => @type } # Create a new record
        end
      end
    end

  end

end
