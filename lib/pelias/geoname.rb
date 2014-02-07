module Pelias

  class Geoname < Base

    attr_accessor :id
    attr_accessor :name
    attr_accessor :alternate_names
    attr_accessor :center_point
    attr_accessor :center_shape
    attr_accessor :feature_class
    attr_accessor :feature_code
    attr_accessor :country_code
    attr_accessor :country_name
    attr_accessor :admin1_code
    attr_accessor :admin1_name
    attr_accessor :admin2_code
    attr_accessor :admin2_name
    attr_accessor :admin3_code
    attr_accessor :admin4_code
    attr_accessor :population

    attr_accessor :locality_name, :local_admin_name, :neighborhood_name

    def suggest_input
      name
    end

    def suggest_output
      name
    end

    def suggest_weight
      0
    end

  end

end
