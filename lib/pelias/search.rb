module Pelias

  class Search < Base

    def self.search(query, viewbox=nil, center=nil)
      query = { query: { match: { name: query } } }
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
      ES_CLIENT.search(index: INDEX, body: query)
    end

    def self.suggest(query)
      ES_CLIENT.suggest(index: INDEX, body: {
          suggestions: {
            text: query,
            completion: {
              field: "suggest",
              size: 20
            }
          } 
        }
      )
    end

  end

end
