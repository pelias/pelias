json.type 'FeatureCollection'

json.features(@hits) do |hit|

  source = hit['_source']

  json.type 'Feature'

  json.geometry source['center_shape']

  json.properties do
    json.name              source['name']
    json.type              source['location_type']
    json.country_code      source['country'].try(:[], 'code')
    json.country_name      source['country_name']
    json.admin0_name       source['admin0'].try(:[], 'name')
    json.admin1_name       source['admin1'].try(:[], 'name')
    json.admin2_name       source['admin2'].try(:[], 'name')
    json.locality_name     source['locality'].try(:[], 'name')
    json.local_admin_name  source['local_admin'].try(:[], 'name')
    json.neighborhood_name source['neighborhood'].try(:[], 'name')

    json.source source

  end

end
