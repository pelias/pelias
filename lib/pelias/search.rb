module Pelias

  class Search < Base

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
