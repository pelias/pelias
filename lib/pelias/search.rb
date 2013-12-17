module Pelias

  class Search < Base

    def self.search(query, viewbox=nil, center=nil, size=10)
      query = { 
        query: { 
          multi_match: {
            query: query,
            fields: [
              "name^2",
              "admin1_code",
              "admin1_name",
              "locality_name",
              "local_admin_name",
              "admin2_name",
              "neighborhood_name",
              "category^4"
            ],
            tie_breaker: 0.5
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

  end

end
