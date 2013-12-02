module Pelias

  class Street < Base

    attr_accessor :id 
    attr_accessor :name
    attr_accessor :center_point
    attr_accessor :center_shape
    attr_accessor :boundaries
    attr_accessor :local_admin_id
    attr_accessor :local_admin_name
    attr_accessor :local_admin_alternate_names
    attr_accessor :local_admin_population
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

    def self.street_level?
      true
    end

    def generate_suggestions
      # TODO take into account alternate names
      input = []
      output = "#{name}"
      if local_admin_name
        input << "#{name} #{local_admin_name}"
        output = "#{name} - #{local_admin_name}"
      end
      if locality_name
        input << "#{name} #{locality_name}"
        output = "#{name} - #{locality_name}"
      end
      if neighborhood_name
        input << "#{name} #{neighborhood_name}"
      end
      input = input.uniq
      if country_code == 'US'
        output << ", #{admin1_code}" if admin1_code
      else
        output << ", #{admin1_name}" if admin1_name
      end
      return {
        input: input,
        output: output,
        payload: { lat: lat, lon: lon, type: type }
      }
    end
  end

end
