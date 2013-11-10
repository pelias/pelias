module Pelias

  class Search < Base

    INDEX = 'pelias'

    def self.suggest(query)
      ES_CLIENT.suggest(index: INDEX, body: {
          suggestions: {
            text: query,
            completion: {
              field: "suggest"
            }
          } 
        }
      )
    end

  end

end
