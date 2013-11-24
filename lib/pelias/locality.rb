module Pelias

  class Locality < Base

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
    attr_accessor :center_point
    attr_accessor :center_shape
    attr_accessor :boundaries

    def generate_suggestions
      # TODO take into account alternate names
      input = "#{@name}"
      output = "#{@name}"
      if @country_code == 'US'
        output << ", #{@admin1_code}" if @admin1_code
      else
        output << ", #{@admin1_name}" if @admin1_name
      end
      return { 
        input: input,
        output: output,
        payload: { lat: lat, lon: lon, type: type }
      }
    end

  end

end
