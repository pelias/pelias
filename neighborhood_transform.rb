def qs_id_for(woe_id, gn_id)
  if gn_id.to_i != 0
    "gn:#{gn_id}"
  elsif woe_id.to_i != 0
    "woe:#{woe_id}"; nil # don't index these for now
  else
    raise 'id not found in attributes'
  end
end

def qs_neighborhood_transform(record)
  attributes = record.attributes.symbolize_keys!
  id = qs_id_for(attributes[:woe_id], attributes[:gn_id])
  return unless id

  Jbuilder.encode do |json|

    # Setup
    boundaries = RGeo::GeoJSON.encode(record.geometry)
    center_shape = RGeo::GeoJSON.encode(record.geometry.centroid)

    # Basic detail
    json.id id
    json.type :neighborhood
    json.boundaries boundaries

    json.array!

    # Normal fields
    json.name attributes[:name]

    # Shape detail
    json.center_shape center_shape
    json.center_point center_shape['coordinates']

  end
end
