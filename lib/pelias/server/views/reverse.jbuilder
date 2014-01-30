source = @result['_source']

json.name source['name']
json.level @result['_type']

if source['_type'] == 'street'
  json.street_name source['street_name']
  json.number      source['number']
end

json.country_name source['country_name']
json.country_code source['country_code']
json.admin1_abbr source['country_code'] == 'US' ? source['admin1_code'] : nil
json.admin1_name source['admin1_name']
json.admin2_name source['admin2_name']
json.locality_name source['locality_name']
json.local_admin_name source['local_admin_name']
json.neighborhood_name source['neighborhood_name']
