module Pelias

  class Search < Base

    def self.search(query, viewbox=nil, center=nil, size=10)
      subqueries = [{
        dis_max: {
          tie_breaker: 0.7,
          boost: 1.2,
          queries: [{ match: { name: query } }]
        }
      }]
      query.split.each do |term|
        subqueries << {
          dis_max: {
            tie_breaker: 0.7,
            boost: 1.2,
            queries: [{
              multi_match: { 
                query: term, 
                fields: ["name", "admin1_code", "admin1_name", 
                  "locality_name", "local_admin_name",
                  "admin2_name", "neighborhood_name", "feature"]
              }
            }]
          }
        }
      end
      query = {
        query: {
          bool: {
            should: subqueries
          }
        }
      }
      if viewbox
        viewbox = viewbox.split(',')
        query[:filter] = {
          geo_bounding_box: {
            center_point: {
              top_left: {
                lat: viewbox[1],
                lon: viewbox[0]
              },
              bottom_right: {
                lat: viewbox[3],
                lon: viewbox[2]
              }
            }
          }
        }
        unless center
          center_lon = ((viewbox[0].to_f-viewbox[2].to_f)/2)+viewbox[2].to_f
          center_lat = ((viewbox[1].to_f-viewbox[3].to_f)/2)+viewbox[3].to_f
          center = "#{center_lon.round(6)},#{center_lat.round(6)}"
        end
      end
      if center
        center = center.split(',')
        query[:sort] = [
          {
            _geo_distance: {
              center_point: [center[0], center[1]],
              order: 'asc',
              unit: 'km'
            }
          }
        ]
      end
      ES_CLIENT.search(index: Pelias::INDEX, body: query, size: size)
    end

    def self.suggest(query, size)
      ES_CLIENT.suggest(index: Pelias::INDEX, body: {
          suggestions: {
            text: query,
            completion: {
              field: "suggest",
              size: size
            }
          } 
        }
      )
    end

    def self.closest(lng, lat, search_type, within_meters=100)
      address_results = ES_CLIENT.search(index: Pelias::INDEX, type: search_type,
        body: {
          query: {
            match_all: {}
          },
          filter: {
            geo_distance: {
              distance: "#{within_meters}m",
              center_point: [lng, lat]
            }
          },
          sort: [{
            _geo_distance: {
              center_point: [lng, lat],
              order: "asc",
              unit: "m"
            }
          }]
        }
      )
    end

    def self.encompassing_shapes(lng, lat)
      ES_CLIENT.search(index: Pelias::INDEX, body:{
        query: {
          filtered: {
            query: { match_all: {} },
            filter: {
              geo_shape: {
                boundaries: {
                  shape: {
                    type: "Point",
                    coordinates: [lng, lat]
                  },
                  relation: "intersects"
                }
              }
            }
          }
        }
      })
    end

    def self.reverse_geocode(lng, lat)
      # try for closest address
      address = closest(lng, lat, 'address')
      unless address['hits']['hits'].empty?
        source = address['hits']['hits'].first['_source']
        return {
          level: 'address',
          name: source['name'],
          number: source['number'],
          street_name: source['street_name'],
          country_code: source['country_code'],
          country_name: source['country_name'],
          admin1_abbr: source['country_code']=='US' ? source['admin1_code'] : nil,
          admin1_name: source['admin1_name'],
          admin2_name: source['admin2_name'],
          locality_name: source['locality_name'],
          local_admin_name: source['local_admin_name'],
          neighborhood_name: source['neighborhood_name']
        }
      end
      # then closest street
      street = closest(lng, lat, 'street')
      unless street['hits']['hits'].empty?
        source = street['hits']['hits'].first['_source']
        return {
          level: 'street',
          name: source['name'],
          country_code: source['country_code'],
          country_name: source['country_name'],
          admin1_abbr: source['country_code']=='US' ? source['admin1_code'] : nil,
          admin1_name: source['admin1_name'],
          admin2_name: source['admin2_name'],
          locality_name: source['locality_name'],
          local_admin_name: source['local_admin_name'],
          neighborhood_name: source['neighborhood_name']
        }
      end
      # otherwise encompassing shapes
      shapes = encompassing_shapes(lng, lat)
      unless shapes['hits']['hits'].empty?
        shapes = shapes['hits']['hits']
        shape = nil
        %w(neighborhood locality local_admin admin2).each do |type|
          shape = shapes.select { |s| s['_type']==type }.first unless shape
        end
        source = shape['_source']
        return {
          level: shape['_type'],
          name: source['name'],
          country_code: source['country_code'],
          country_name: source['country_name'],
          admin1_abbr: source['country_code']=='US' ? source['admin1_code'] : nil,
          admin1_name: source['admin1_name'],
          admin2_name: source['admin2_name'],
          locality_name: source['locality_name'],
          local_admin_name: source['local_admin_name'],
          neighborhood_name: source['neighborhood_name']
        }
      end
      nil
    end

  end

end
