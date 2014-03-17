module Pelias

  class Poi < Location

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
        :center_point => center['coordinates']
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
