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

    def grab_parents(shape_types)
      return if shape_types.empty?
      update do |_id, entry|

        if shape_types.include?(:admin0)
          query = "SELECT qs_iso_cc,qs_adm0 FROM qs.qs_admin0 WHERE ST_Contains(geom, ST_GeometryFromText('#{entry['center_point']}'))";
          if result = Pelias::PG_CLIENT.exec(query).first
            entry['admin0_abbr'] = result['qs_iso_cc']
            entry['admin0_name'] = result['qs_adm0']
          end
        end

        if shape_types.include?(:admin1)
          query = "SELECT qs_iso_cc,qs_a1 FROM qs.qs_admin1 WHERE ST_Contains(geom, ST_GeometryFromText('#{entry['center_point']}'))";
          if result = Pelias::PG_CLIENT.exec(query).first
            entry['admin1_name'] = result['qs_a1']
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
