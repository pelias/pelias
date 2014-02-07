module Pelias

  class Location < Base

    attr_accessor :id # gn
    attr_accessor :name # gn

    attr_accessor :boundaries
    attr_accessor :center_point # gn
    attr_accessor :center_shape # gn

    attr_accessor :number
    attr_accessor :street_name
    attr_accessor :phone
    attr_accessor :website
    attr_accessor :feature
    attr_accessor :population # gn
    attr_accessor :elevation # gn
    attr_accessor :alternate_names # gn
    attr_accessor :country_code # gn
    attr_accessor :country_name

    attr_accessor :admin1_code # gn
    attr_accessor :admin1_name

    attr_accessor :admin2_id
    attr_accessor :admin2_code # gn
    attr_accessor :admin2_name
    attr_accessor :admin2_alternate_names
    attr_accessor :admin2_population

    attr_accessor :admin3_code # gn

    attr_accessor :admin4_code # gn

    attr_accessor :locality_id
    attr_accessor :locality_name
    attr_accessor :locality_alternate_names
    attr_accessor :locality_population

    attr_accessor :local_admin_id
    attr_accessor :local_admin_name
    attr_accessor :local_admin_alternate_names
    attr_accessor :local_admin_population

    attr_accessor :neighborhood_id
    attr_accessor :neighborhood_name
    attr_accessor :neighborhood_alternate_names
    attr_accessor :neighborhood_population

    attr_accessor :feature_class # gn
    attr_accessor :feature_code # gn

  end

end
