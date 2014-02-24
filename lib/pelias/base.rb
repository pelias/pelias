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
      obj.pre_process
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
      self.name.split('::').last.gsub(/(.)([A-Z])/,'\1_\2').downcase
    end

    def admin1_abbr
      admin1_code if country_code == 'US'
    end

    def lat
      center_point[1]
    end

    def lon
      center_point[0]
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
      {
        input: suggest_input,
        output: suggest_output,
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
          local_admin_name: local_admin_name,
          neighborhood_name: neighborhood_name
        }
      }
    end

    def to_hash
      hash ={}
      self.instance_variables.each do |var|
        hash[var.to_s.delete("@")] = self.instance_variable_get(var)
      end
      hash.delete_if { |k,v| v=='' || v.nil? || (v.is_a?(Array) && v.empty?) }
      hash
    end

    private

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
