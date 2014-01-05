module Pelias

  class Base

    include Sidekiq::Worker

    def initialize(params)
      set_instance_variables(params)
    end

    def save
      attributes = to_hash
      id = attributes.delete('id')
      suggestions = generate_suggestions
      attributes['suggest'] = suggestions if suggestions
      ES_CLIENT.index(index: Pelias::INDEX, type: type, id: id,
        body: attributes, timeout: "#{ES_TIMEOUT}s")
    end

    def update(params)
      set_instance_variables(params)
    end

    def self.build(params)
      obj = self.new(params)
      obj.pre_process # TODO should call the below?
      obj.set_encompassing_shapes
      obj.set_admin_names
      obj
    end

    def self.create(params)
      if params.is_a? Array
        bulk = params.map do |param|
          obj = self.build(param)
          hash = obj.to_hash
          suggestions = obj.generate_suggestions
          hash['suggest'] = suggestions if suggestions
          { index: { _id: hash.delete('id'), data: hash } }
        end
        ES_CLIENT.bulk(index: Pelias::INDEX, type: type, body: bulk)
      else
        obj = self.build(params)
        obj.save
        obj
      end
    end

    def self.find(id)
      result = ES_CLIENT.get(index: Pelias::INDEX, type: type, id: id,
        ignore: 404)
      return unless result
      obj = self.new(:id=>id)
      obj.update(result['_source'])
      obj
    end

    def self.type
      class.name.split('::').last.gsub(/(.)([A-Z])/,'\1_\2').downcase
    end

    def self.street_level?
      false
    end

    # ACCEPTS OPTIONS
    # :size => 50
    # :start_from => 0
    # :update_encompassing_shapes => false
    # :update_geometries => false
    def self.reindex_all(params={})
      size = params[:size] || 50
      start_from = params[:start_from] || 0
      i=0
      results = Pelias::ES_CLIENT.search(index: Pelias::INDEX,
        type: self.type, scroll: '10m', size: size,
        body: { query: { match_all: {} }, sort: '_id' })
      puts i
      i+=size
      self.delay.reindex_bulk(results, params) if i >= start_from
      begin
        results = Pelias::ES_CLIENT.scroll(scroll: '10m',
          scroll_id: results['_scroll_id'])
        begin
          self.delay.reindex_bulk(results, params) if i >= start_from
        rescue
          sleep 20
          self.delay.reindex_bulk(results, params) if i >= start_from
        end
        puts i
        i+=size
      end while results['hits']['hits'].count > 0
    end

    def self.reindex_bulk(results, params)
      bulk = results['hits']['hits'].map do |result|
        obj = self.new(result['_source'])
        if params[:update_encompassing_shapes]
          obj.set_encompassing_shapes
          obj.pre_process
        end
        to_reindex = obj.to_hash
        unless params[:update_geometries]
          to_reindex.delete('center_point')
          to_reindex.delete('center_shape')
          to_reindex.delete('boundaries')
        end
        to_reindex['suggest'] = obj.generate_suggestions
        {
          update: {
            _id: result['_id'],
            data: { doc: to_reindex }
          }
        }
      end
      Pelias::ES_CLIENT.bulk(index: Pelias::INDEX, type: type, body: bulk)
    end

    def admin1_abbr
      admin1_code if country_code=='US'
    end

    def lat
      center_point[1]
    end

    def lon
      center_point[0]
    end

    def encompassing_shapes
      # to override on objects with encompassing shapes
      []
    end

    def set_encompassing_shapes
      encompassing_shapes.each do |shape_type|
        if shape = encompassing_shape(shape_type)
          source = shape['_source']
          self.update(
            "#{shape_type}_id".to_sym => shape['_id'],
            "#{shape_type}_name".to_sym => source['name'],
            "#{shape_type}_alternate_names".to_sym => source['alternate_names'],
            "#{shape_type}_population".to_sym => source['population'],
            :country_code => source['country_code'],
            :country_name => source['country_name'],
            :admin1_code => source['admin1_code'],
            :admin1_name => source['admin1_name']
          )
        end
      end
    end

    def set_admin_names
      if respond_to?(:country_name)
        country = country_codes[country_code]
        self.country_name = country[:name] if country
      end
      if respond_to?(:admin1_name)
        admin1 = admin1_codes["#{country_code}.#{admin1_code}"]
        self.admin1_name = admin1[:name] if admin1
      end
    end

    def pre_process
      # to override
    end

    def country_codes
      @@country_codes ||= YAML::load(
        File.open('lib/pelias/data/geonames/countries.yml')
      )
    end

    def admin1_codes
      @@admin1_codes ||= YAML::load(
        File.open('lib/pelias/data/geonames/admin1.yml')
      )
    end

    def generate_suggestions
      # to override
    end

    def to_hash
      hash ={}
      self.instance_variables.each do |var|
        hash[var.to_s.delete("@")] = self.instance_variable_get(var)
      end
      hash.delete_if { |k,v| v=='' || v.nil? || (v.is_a?(Array) && v.empty?) }
      hash
    end

    def closest_geoname
      begin
        # try for a geoname with a matching name & type
        results = ES_CLIENT.search(index: Pelias::INDEX, type: 'geoname',
          body: {
          query: {
            filtered: {
              query: {
                bool: {
                  must: [
                    match: { name: name.force_encoding('UTF-8') }
                  ],
                  should: [
                    match: { feature_class: 'P' }
                  ]
                }
              },
              filter: {
                geo_shape: {
                  center_shape: {
                    shape: boundaries,
                    relation: 'intersects'
                  }
                }
              }
            }
          }
        })
        # if not try any in boundaries
        if results['hits']['total'] == 0
          results = ES_CLIENT.search(index: Pelias::INDEX, type: 'geoname',
            body: {
            query: {
              filtered: {
                query: { match_all: {} },
                filter: {
                  geo_shape: {
                    center_shape: {
                      shape: boundaries,
                      relation: 'intersects'
                    }
                  }
                }
              }
            }
          })
        end
        if result = results['hits']['hits'].first
          geoname = Pelias::Geoname.new(:id=>result['_id'])
          geoname.update(result['_source'])
          geoname
        else
          nil
        end
      rescue
        nil
      end
    end

    private

    def encompassing_shape(shape_type)
      results = ES_CLIENT.search(index: Pelias::INDEX, type: shape_type, body: {
        query: {
          filtered: {
            query: { match_all: {} },
            filter: {
              geo_shape: {
                boundaries: {
                  shape: center_shape,
                  relation: 'intersects'
                }
              }
            }
          }
        }
      })
      results['hits']['hits'].first
    end

    def set_instance_variables(params)
      params.keys.each do |key|
        m = "#{key.to_s}="
        self.send(m, params[key]) if self.respond_to?(m)
      end
      true
    end

    def symbolize_keys(hash)
      hash.keys.each do |key|
        hash[(key.to_sym rescue key) || key] = hash.delete(key)
      end
    end

    def type
      self.class.type
    end

  end

end
