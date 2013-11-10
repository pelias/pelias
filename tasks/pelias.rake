require 'pelias'

namespace :pelias do

  desc "setup index & mappings"
  task :setup do
    schema_file = File.read('schemas/pelias.json')
    schema_json = JSON.parse(schema_file)
    Pelias::Base::ES_CLIENT.indices.create(index: 'pelias', body: schema_json)
  end

  desc "build pelias index"
  task :build_index do
    index_neighborhoods
    index_localities
  end

  def index_neighborhoods
    # TODO
  end

  def index_localities
    client = Pelias::Base::ES_CLIENT
    results = client.search(index: 'quattroshapes', type: 'locality')
    total_results = results['hits']['total']
    from, localities = 0, 0
    begin
      results['hits']['hits'].each do |locality|
        localities += 1
        add_locality_to_index(locality)
        streets = get_streets(locality['_id'], 'locality')
        streets.each do |street|
          add_street_to_index(street, locality)
          add_addresses_to_index(street, locality)
        end
      end
      from += 10
      results = client.search(index: 'quattroshapes', type: 'locality',
        from: from)
    end while localities < total_results
  end

  def add_locality_to_index(locality)
    Pelias::Locality.create(
      :id => locality['_id'],
      :name => locality['_source']['name'],
      :alternate_names => locality['_source']['alternate_names'],
      :country_code => locality['_source']['country_code'],
      :admin1_code => locality['_source']['admin1_code'],
      :admin2_code => locality['_source']['admin2_code'],
      :admin3_code => locality['_source']['admin3_code'],
      :admin4_code => locality['_source']['admin4_code'],
      :population => locality['_source']['population'],
      :centerpoint => locality['_source']['centerpoint'],
      :boundaries => locality['_source']['boundaries']
    )
  end

  def add_street_to_index(street, locality)
    Pelias::Street.create(
      :id => street[:id],
      :name => street[:name],
      :location => street[:location],
      :locality_id => locality['_id'],
      :locality_name => locality['_source']['name'],
      :locality_alternate_names => locality['_source']['alternate_names'],
      :locality_country_code => locality['_source']['country_code'],
      :locality_admin1_code => locality['_source']['admin1_code'],
      :locality_admin2_code => locality['_source']['admin2_code'],
      :locality_admin3_code => locality['_source']['admin3_code'],
      :locality_admin4_code => locality['_source']['admin4_code'],
      :locality_population => locality['_source']['population']
    )
  end

  def add_addresses_to_index(street, locality)
    addresses = get_addresses(street[:id])
    addresses.each do |address|
      Pelias::Address.create(
        :id => address[:id],
        :number => address[:number],
        :location => address[:location],
        :street_id => street[:id],
        :street_name => street[:name],
        :locality_id => locality['_id'],
        :locality_name => locality['_source']['name'],
        :locality_alternate_names => locality['_source']['alternate_names'],
        :locality_country_code => locality['_source']['country_code'],
        :locality_admin1_code => locality['_source']['admin1_code'],
        :locality_admin2_code => locality['_source']['admin2_code'],
        :locality_admin3_code => locality['_source']['admin3_code'],
        :locality_admin4_code => locality['_source']['admin4_code'],
        :locality_population => locality['_source']['population']
      )
    end
  end

  def get_addresses(street_id)
    client = Pelias::Base::ES_CLIENT
    addresses = []
    query = { query: { term: { _parent: street_id } } }
    results = client.search(index: 'openstreetmap', type: 'address',
      body: query)
    total_results = results['hits']['total']
    from = 0
    begin
      results['hits']['hits'].each do |address|
        addresses << {
          :id => address['_id'],
          :number => address['_source']['properties']['number'],
          :location => address['_source']['properties']['location']
        }
      end
      from += 10
      results = client.search(index: 'openstreetmap', type: 'address',
        from: from, body: query)
    end while addresses.count < total_results
    addresses
  end

  def get_streets(id, type)
    client = Pelias::Base::ES_CLIENT
    streets = []
    query = { query: {
      filtered: {
          query: { match_all: {} },
          filter: {
            geo_shape: {
              location: {
                indexed_shape: {
                  id: id,
                  type: type,
                  index: 'quattroshapes',
                  shape_field_name: 'boundaries'
                }
              }
            }
          }
        }
      }
    }
    results = client.search(index: 'openstreetmap', type: 'street', body: query)
    total_results = results['hits']['total']
    from = 0
    begin
      results['hits']['hits'].each do |street|
        streets << {
          :id => street['_id'],
          :name => street['_source']['name'],
          :location => street['_source']['location']
        }
      end
      from += 10
      results = client.search(index: 'openstreetmap', type: 'street',
        from: from, body: query)
    end while streets.count < total_results
    streets
  end

end
