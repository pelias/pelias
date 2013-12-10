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
    attr_accessor :locality_id
    attr_accessor :locality_name
    attr_accessor :locality_alternate_names
    attr_accessor :locality_population
    attr_accessor :local_admin_id
    attr_accessor :local_admin_name
    attr_accessor :local_admin_alternate_names
    attr_accessor :local_admin_population
    attr_accessor :center_point
    attr_accessor :center_shape
    attr_accessor :boundaries

    def reindex(update_geometries=false)
      to_reindex = self.to_hash
      to_reindex.delete('id')
      unless update_geometries
        to_reindex.delete('center_point')
        to_reindex.delete('center_shape')
        to_reindex.delete('boundaries')
      end
      to_reindex['suggest'] = generate_suggestions
      Pelias::ES_CLIENT.update(index: INDEX, type: type, id: id, 
        body: { doc: to_reindex })
    end

    def admin1_abbr
      admin1_code if country_code=='US'
    end

    def generate_suggestions
      input = "#{name}"
      output = "#{name}"
      if local_admin_name
        input << " #{local_admin_name}"
        output << ", #{local_admin_name}"
      elsif locality_name
        input << " #{locality_name}"
        output << ", #{locality_name}"
      end
      if admin1_abbr
        input << " #{admin1_abbr}" 
        output << ", #{admin1_abbr}"
      elsif admin1_name
        input << " #{admin1_name}"
        output << ", #{admin1_name}"
      end
      {
        input: input,
        output: output,
        payload: {
          lat: lat,
          lon: lon,
          type: type,
          country_code: country_code,
          country_name: country_name,
          admin1_abbr: admin1_abbr,
          admin1_name: admin1_name,
          admin2_name: admin2_name,
          locality_name: locality_name,
          local_admin_name: local_admin_name
        }
      }
    end

  end

end
