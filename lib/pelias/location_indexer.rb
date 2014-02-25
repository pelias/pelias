module Pelias
  class LocationIndexer

    include Sidekiq::Worker

    def perform(bulk)
      ES_CLIENT.bulk(index: Pelias::INDEX, type: 'location', body: bulk)
    end

  end
end
