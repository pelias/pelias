json.type 'FeatureCollection'

json.features(@hits) do |hit|

  payload = hit['payload']

  json.type 'Feature'

  json.geometry do
    json.type 'Point'
    json.coordinates [payload['lon'], payload['lat']]
  end

  json.properties do
    json.name              hit['text']
    json.type              payload['type']
    json.country_code      payload['country_code']
    json.country_name      payload['country_name']
    json.admin1_abbr       payload['admin1_abbr']
    json.admin1_name       payload['admin1_name']
    json.admin2_name       payload['admin2_name']
    json.locality_name     payload['locality_name']
    json.local_admin_name  payload['local_admin_name']
    json.neighborhood_name payload['neighborhood_name']
  end

end
