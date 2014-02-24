json.type 'FeatureCollection'

json.features(@hits) do |hit|

  source = hit['_source']

  json.type 'Feature'

  json.geometry do
    type 'Point'
    coordinates source['center_point']
  end

  json.properties do
    json.osm_id            hit['_id']
    json.name              source['name']
    json.street_number     source['number']
    json.street_name       source['street_name']
    json.feature           source['feature']
    json.phone             source['phone']
    json.website           source['website']
    json.country_code      source['country_code']
    json.country_name      source['country_name']
    json.admin1_abbr       source['admin1_code']
    json.admin1_name       source['admin1_name']
    json.admin2_name       source['admin2_name']
    json.locality_name     source['locality_name']
    json.local_admin_name  source['local_admin_name']
    json.neighborhood_name source['neighborhood_name']
  end

end
