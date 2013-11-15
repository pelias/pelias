module Pelias

  class Street < Base

    attr_accessor :id 
    attr_accessor :name
    attr_accessor :location
    attr_accessor :boundaries
    attr_accessor :locality_id
    attr_accessor :locality_name
    attr_accessor :locality_alternate_names
    attr_accessor :locality_population
    attr_accessor :neighborhood_id
    attr_accessor :neighborhood_name
    attr_accessor :neighborhood_alternate_names
    attr_accessor :neighborhood_population
    attr_accessor :country_code
    attr_accessor :country_name
    attr_accessor :admin1_code
    attr_accessor :admin1_name
    attr_accessor :admin2_code
    attr_accessor :admin2_name
    attr_accessor :admin3_code
    attr_accessor :admin4_code

    def lat
      (@location['coordinates'] || @location[:coordinates])[1].to_f
    end

    def lon
      (@location['coordinates'] || @location[:coordinates])[0].to_f
    end

    def self.street_level?
      true
    end

    private

    def generate_suggestions
      # TODO take into account alternate names
      input = "#{@name} #{@locality_name} #{@locality_admin1_code}"
      output = @name
      output << " - #{@locality_name}" if @locality_name
      output << ", #{@locality_admin1_code}" if @locality_admin1_code
      return {
        input: @name,
        output: "#{@name} - #{@locality_name}, #{@locality_admin1_code}",
        payload: { lat: lat, lon: lon, type: type }
      }
    end

  end

end
