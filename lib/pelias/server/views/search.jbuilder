json.type 'FeatureCollection'

json.features(@hits) do |hit|

  source = hit['_source'] || hit['payload']

  json.type 'Feature'

  json.geometry do
    json.type 'Point'
    json.coordinates source['center_point']
  end

  json.properties do

    # Basics
    json.type              source['location_type']
    json.name              source['name']

    # Out of place, coming soon
    json.country_code      source['country_code']
    json.country_name      source['country_name']

    # Names
    json.admin0_name       source['admin0_name']
    json.admin1_name       source['admin1_name']
    json.admin2_name       source['admin2_name']
    json.local_admin_name  source['local_admin_name']
    json.locality_name     source['locality_name']
    json.neighborhood_name source['neighborhood_name']
    json.street_name       source['street_name']

  end

end
