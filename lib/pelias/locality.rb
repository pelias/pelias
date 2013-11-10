module Pelias

  class Locality < Base

    INDEX = 'pelias'
    TYPE = 'locality'

    def initialize(params)
      @id = params[:id]
      @name = params[:name]
      @alternate_names = params[:alternate_names]
      @country_code = params[:country_code]
      @admin1_code = params[:admin1_code]
      @admin2_code = params[:admin2_code]
      @admin3_code = params[:admin3_code]
      @admin4_code = params[:admin4_code]
      @population = params[:population]
      @centerpoint = params[:centerpoint]
      @boundaries = params[:boundaries]
    end

    def save
      ES_CLIENT.index(index: INDEX, type: TYPE, id: @id,
        body: {
          name: @name,
          alternate_names: @alternate_names,
          country_code: @country_code,
          admin1_code: @admin1_code,
          admin2_code: @admin2_code,
          admin3_code: @admin3_code,
          admin4_code: @admin4_code,
          population: @population,
          centerpoint: @centerpoint,
          boundaries: @boundaries,
          suggest: generate_suggestions
        }
      )
    end

    def generate_suggestions
      # TODO take into account alternate names
      # TODO fix bug in lat/lon here
      return {
        input: @name,
        output: "#{@name}, #{@admin1_code}",
        payload: {
          lat: @centerpoint['lon'].to_f,
          lon: @centerpoint['lat'].to_f,
          type: 'locality'
        }
      }
    end

    def self.create(params)
      locality = Locality.new(params)
      locality.save
      locality
    end

    def self.find(id)
      # TODO
    end

  end

end
