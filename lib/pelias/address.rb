module Pelias

  class Address < Base

    INDEX = 'pelias'
    TYPE = 'address'

    def initialize(params)
      @id = params[:id]
      @number = params[:number]
      @location = params[:location]
      @street_id = params[:street_id]
      @street_name = params[:street_name]
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
          number: @number,
          location: @location,
          street_id: @street_id,
          street_name: @street_name,
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
      input = "#{@number} #{@street_name}"
      output = "#{@number} - #{@street_name} "
      output << "#{@locality_name}, #{@locality_admin1_code}"
      return {
        input: input,
        output: output
      }
    end

    def self.create(params)
      address = Address.new(params)
      address.save
      address
    end

    def self.find(id)
      # TODO
    end

  end

end
