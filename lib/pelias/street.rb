module Pelias

  class Street < Base

    BULK_INDEX_BATCH_SIZE = 100

    def self.index_all
      results = PG_CLIENT.exec("
        SELECT osm_id, name,
          ST_AsGeoJSON(ST_Transform(way, 4326), 6) AS location
        FROM planet_osm_line
        WHERE name IS NOT NULL AND highway IS NOT NULL
      ")
      results.each_slice(BULK_INDEX_BATCH_SIZE) do |result|
        ES_CLIENT.bulk body: result.map { |street| { index: {
          _index: 'pelias', _type: 'street', _id: street['osm_id'],
          data: {
            name: street['name'],
            location: JSON.parse(street['location'])
          }
        }}}
      end
    end

  end

end
