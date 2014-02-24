json.type 'FeatureCollection'

json.features(@hits) do |hit|

  source = hit['_source']

  json.type 'Feature'

  json.geometry do
    json.type 'Point'
    json.coordinates source['center_point']
  end

  json.properties do

    json.name              source['name']
    json.type              source['location_type']
    json.country_code      source['country_code']
    json.country_name      source['country_name']
    json.admin0_name       source['admin0_name']
    json.admin1_name       source['admin1_name']
    json.admin2_name       source['admin2_name']
    json.locality_name     source['locality_name']
    json.local_admin_name  source['local_admin_name']
    json.neighborhood_name source['neighborhood_name']

    source.delete 'boundaries'
    source.delete 'center_shape'
    json.source source

  end

end
