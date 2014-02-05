module Pelias

  class Poi < Base

    SUGGEST_WEIGHT = 6

    attr_accessor :id
    attr_accessor :name
    attr_accessor :number
    attr_accessor :phone
    attr_accessor :website
    attr_accessor :feature
    attr_accessor :center_point
    attr_accessor :center_shape
    attr_accessor :street_name
    attr_accessor :country_code
    attr_accessor :country_name
    attr_accessor :admin1_code
    attr_accessor :admin1_name
    # encompassing shape attributes
    attr_accessor :admin2_id
    attr_accessor :admin2_name
    attr_accessor :admin2_alternate_names
    attr_accessor :admin2_population
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

    def encompassing_shapes
      %w(admin2 local_admin locality neighborhood)
    end

    def suggest_weight
      (locality_name || local_admin_name) ? SUGGEST_WEIGHT : 0
    end

    def suggest_input
      input = []
      ns_str, s_str = nil
      if number && street_name
        ns_str = "#{name} #{number} #{street_name}"
      elsif street_name
        s_str = "#{name} #{street_name}"
      end
      if local_admin_name
        input << "#{name} #{local_admin_name}"
        input << "#{ns_str} #{local_admin_name}" if ns_str
        input << "#{s_str} #{local_admin_name}" if s_str
      end
      if locality_name
        input << "#{name} #{locality_name}"
        input << "#{ns_str} #{locality_name}" if ns_str
        input << "#{s_str} #{locality_name}" if s_str
      end
      if neighborhood_name
        input << "#{name} #{neighborhood_name}"
        input << "#{ns_str} #{neighborhood_name}" if ns_str
        input << "#{s_str} #{neighborhood_name}" if s_str
      end
      if admin2_name
        input << "#{name} #{admin2_name}"
        input << "#{ns_str} #{admin2_name}" if ns_str
        input << "#{s_str} #{admin2_name}" if s_str
      end
      input
    end

    def generate_suggestions
      {
        input: suggest_input,
        weight: suggest_weight,
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

    def pre_process
      self.feature = self.feature.map { |f| f.strip.downcase.gsub('_', ' ') }
      to_add = []
      feature.map { |f| to_add << feature_synonyms[f] }
      self.feature << to_add
      self.feature = feature.flatten.compact.uniq
      feature_deletions.each { |d| self.feature.delete(d) }
    end

    def feature_deletions
      @@feature_deletions ||= YAML::load(File.open('config/feature_deletions.yml'))
    end

    def feature_synonyms
      @@feature_synonyms ||= YAML::load(File.open('config/feature_synonyms.yml'))
    end

    def self.osm_features
      %w(aerialway aeroway amenity building craft cuisine historic
         landuse leisure man_made military natural office public_transport
         railway shop sport tourism waterway)
    end

    def self.get_sql(shape)
      "SELECT
         osm_id, name, phone, website,
         \"addr:street\" AS street_name,
         \"addr:housenumber\" AS housenumber,
         ST_AsGeoJSON(ST_Transform(ST_Centroid(way), 4326), 6) AS location,
         \"#{osm_features * '","'}\"
      FROM planet_osm_#{shape}
      WHERE name IS NOT NULL
        AND (\"#{osm_features * '" IS NOT NULL OR "'}\" IS NOT NULL)
      ORDER BY osm_id"
    end

    def self.create_hash(result, shape)
      result = result.delete_if { |k,v| v.nil? }
      center = JSON.parse(result.delete('location'))
      return_hash = {
        :id => "#{shape}-#{result.delete('osm_id')}",
        :name => result.delete('name'),
        :number => result.delete('housenumber'),
        :street_name => result.delete('street_name'),
        :website => result.delete('website'),
        :phone => result.delete('phone'),
        :center_point => center['coordinates'],
        :center_shape => center
      }
      feature = result.map { |k,v|
        features = [k]
        if v[',']
          features << v.split(',')
        elsif v[';']
          features << v.split(';')
        elsif v[':']
          features << v.split(':')
        else
          features << v
        end
        features.flatten.compact.uniq.map { |f|
          f.gsub('_', ' ').downcase.strip.gsub(' ', '_').gsub('"', '')
        }
      }
      return_hash[:feature] = feature.flatten.compact.uniq
      return_hash
    end

  end

end
