module Pelias

  class Base

    ES_CLIENT = Elasticsearch::Client.new log: false
    PG_CLIENT = PG.connect dbname: 'osm'

  end

end
