module Pelias

  class Poi

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
