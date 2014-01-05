module Pelias

  class Restaurant < Poi

    FEATURES_TO_DELETE = %w(amenity restaurant cuisine)
    FEATURES_TO_ADD = %w(restaurant food dining)
    FEATURES_TO_REPLACE = {
      'fast_food' => 'fast'
    }

    def pre_process
      FEATURES_TO_DELETE.each { |d| self.feature.delete(d) }
      FEATURES_TO_ADD.each { |a| self.feature << a }
      FEATURES_TO_REPLACE.each { |k,v| self.feature << v if self.feature.delete(k) }
      self.feature = self.feature.map { |f| f.gsub('_', ' ') }
      to_add = []
      feature.map { |f| to_add << feature_synonyms[f] }
      self.feature << to_add
      self.feature = feature.flatten.compact.uniq
    end

    def self.get_sql(shape)
      "SELECT osm_id, name, \"addr:street\" AS street_name,
        \"addr:housenumber\" AS housenumber, phone, website,
        amenity, cuisine, diet,
        ST_AsGeoJSON(ST_Transform(ST_Centroid(way), 4326), 6) AS location
      FROM planet_osm_#{shape}
      WHERE (amenity='restaurant' OR amenity='fast_food'
        OR cuisine IS NOT NULL OR diet IS NOT NULL)
        AND name IS NOT NULL
      ORDER BY osm_id"
    end

  end

end
