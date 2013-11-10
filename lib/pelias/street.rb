module Pelias

  class Street < Base

    INDEX = 'pelias'
    TYPE = 'street'

    def initialize(params)
      @id = params[:id]
      @name = params[:name]
      @location = params[:location]
      @locality_id = params[:locality_id]
      @locality_name = params[:locality_name]
      @locality_alternate_names = params[:locality_alternate_names]
      @locality_country_code = params[:locality_country_code]
      @locality_admin1_code = params[:locality_admin1_code]
      @locality_admin2_code = params[:locality_admin2_code]
      @locality_admin3_code = params[:locality_admin3_code]
      @locality_admin4_code = params[:locality_admin4_code]
      @locality_population = params[:locality_population]
    end

    def save
      ES_CLIENT.index(index: INDEX, type: TYPE, id: @id,
        body: {
          name: @name,
          location: @location,
          locality_id: @locality_id,
          locality_name: @locality_name,
          locality_alternate_names: @locality_alternate_names,
          locality_country_code: @locality_country_code,
          locality_admin1_code: @locality_admin1_code,
          locality_admin2_code: @locality_admin2_code,
          locality_admin3_code: @locality_admin3_code,
          locality_admin4_code: @locality_admin4_code,
          locality_population: @locality_population,
          suggest: generate_suggestions
        }
      )
    end

    def generate_suggestions
      # TODO take into account alternate names
      return {
        input: @name,
        output: "#{@name} - #{@locality_name}, #{@locality_admin1_code}"
      }
    end

    def self.create(params)
      street = Street.new(params)
      street.save
      street
    end

    def self.find(id)
      # TODO
    end

  end

end
