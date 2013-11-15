module Pelias

  class Neighborhood < Base

    attr_accessor :id
    attr_accessor :name
    attr_accessor :alternate_names
    attr_accessor :country_code
    attr_accessor :country_name
    attr_accessor :admin1_code
    attr_accessor :admin1_name
    attr_accessor :admin2_code
    attr_accessor :admin2_name
    attr_accessor :admin3_code
    attr_accessor :admin4_code
    attr_accessor :population
    attr_accessor :location
    attr_accessor :boundaries

    def lat
      (@location['coordinates'] || @location[:coordinates])[1].to_f
    end

    def lon
      (@location['coordinates'] || @location[:coordinates])[0].to_f
    end

    def all_streets
      streets = []
      from = 0
      begin
        results = ES_CLIENT.search(index: INDEX, type: 'street',
          body: geo_query, from: from)
        results['hits']['hits'].each { |street| streets << street }
        total_results = results['hits']['total']
        from += 10
      end while streets.count < total_results
      streets
    end

    def all_addresses
      addresses = []
      from = 0
      begin
      results = ES_CLIENT.search(index: INDEX, type: 'address',
        body: geo_query, from: from)
      results['hits']['hits'].each { |address| addresses << address }
        total_results = results['hits']['total']
        from += 10
      end while addresses.count < total_results
      addresses
    end

    private

    def generate_suggestions
      # TODO take into account alternate names
      {
        input: @name,
        output: "#{@name}, #{@admin1_code}",
        payload: { lat: lat, lon: lon, type: type }
      }
    end

  end

end
