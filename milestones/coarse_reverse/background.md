# Reverse Geocoding

## Overview
The /reverse endpoint as it works now is more search than geocoding.  That is, it returns POIs near a lat/lng in addition to a street.  The reverse endpoint should be re-worked to act more like a traditional reverse geocoder with optional parameters or URL paths to expose extended functionality.  

## Ideal Functionality

Reverse geocoders normally have the following attributes:

- return a single result
- single milliseconds performance
- a house number + street is the ideal return value, but there are fallbacks:
 1. point house number + street name within, say, `x` meters of the input point
 2. interpolated house number + street name where input point is contained within a fat street line string of known blocks
 3. street name where input point is contained within a fat street line string of a street outside of known blocks
 4. venue polygon
 5. neighborhood polygon
 6. city polygon
 7. county polygon
 8. region polygon (at least outside the US, I can’t think of a place that’s outside of a county but within a region)
 9. country polygon (if there are points outside of all regions, counties, cities, etc)
 10. water feature polygon (Gulf of Mexico, Pacific Ocean, etc) 

Until we get interpolated data, we can't do numbers 2 or 3, so initially a greater radius benefits us.  That can probably be reduced once we support interpolation.  

There’s at least one caveat when it comes to point house numbers with `x` meters of the input point in that there will be points in a water polygon and outside of a country but within `x` meters of a point house number (think of houses between the road and ocean).  In this case, we could detect if point is also within the water polygon and reject the ES lookup.  

The logic for reverse geocoding becomes:

1. Query Elasticsearch for
  - layers=address
  - sources=OA,OSM
  - size=1
  - sort=geodistance
  - radius=`x` meters
2. If there’s a result from #1, return it
3. If there’s no result from #1, call WoF PiP and return the most granular result (filtering out lower-tier neighborhoods)

Arguably, OpenAddresses should be favored over OSM since it’s more authoritative.  

### What’s Nearby

Currently the /reverse endpoint doesn’t discriminate between layers but with the move to the above functionality, a parameter (something like `pois=true` or `v1/reverse/pois`), can be added to return POIs near the point instead of addresses.  

### Coarse

The existing /reverse endpoint also supports a `coarse` parameter but also looks for the nearest centroid at the specified layer which can lead to misleading behavior.  For example, this request searches for the nearest country to a lat/lon in New Mexico:

[Socorro, NM, USA](https://search.mapzen.com/v1/reverse?api_key=search-xDYkNp8&point.lat=34.064250&point.lon=-106.903453&layers=country)

The radius is 500km (at the time of writing this) but the center of the US is not within this range.  

In this request, the input lat/lon is in Italy but just outside of Vatican City, so Vatican City gets returned first.

[Just outside of Vatican City](https://search.mapzen.com/v1/reverse?api_key=search-xDYkNp8&point.lat=41.906228&point.lon=12.444851&layers=country&size=1)

As a consumer of a reverse geocoder, I would expect a coarse reverse geocode to operate like a PiP service, not a within-a-radius behavior.

## Examples

### Dense Town

This ES query returns a single result in a densely packed town (within 61 meters / 200 feet):

```
GET pelias/address/_search
{
  "query": {
    "filtered": {
      "query": {
        "bool": {
          "must": []
        }
      },
      "filter": {
        "bool": {
          "must": [
            {
              "geo_distance": {
                "distance": "61m",
                "distance_type": "plane",
                "optimize_bbox": "indexed",
                "_cache": true,
                "center_point": {
                  "lat": 39.898746,
                  "lon": -76.606958
                }
              }
            },
            {
              "terms": {
                "source": [
                  "openaddresses",
                  "openstreetmap"
                ]
              }
            }
          ]
        }
      }
    }
  },
  "size": 1,
  "track_scores": true,
  "sort": [
    "_score",
    {
      "_geo_distance": {
        "order": "asc",
        "distance_type": "plane",
        "center_point": {
          "lat": 39.898746,
          "lon": -76.606958
        }
      }
    }
  ]
}
```

### Sparsely-developed Area

This ES query returns a single result in a sparsely-developed housing development (within 61 meters / 200 feet):

```
GET pelias/address/_search
{
  "query": {
    "filtered": {
      "query": {
        "bool": {
          "must": []
        }
      },
      "filter": {
        "bool": {
          "must": [
            {
              "geo_distance": {
                "distance": "61m",
                "distance_type": "plane",
                "optimize_bbox": "indexed",
                "_cache": true,
                "center_point": {
                  "lat": 39.934408,
                  "lon": -76.734529
                }
              }
            },
            {
              "terms": {
                "source": [
                  "openaddresses",
                  "openstreetmap"
                ]
              }
            }
          ]
        }
      }
    }
  },
  "size": 4,
  "track_scores": true,
  "sort": [
    "_score",
    {
      "_geo_distance": {
        "order": "asc",
        "distance_type": "plane",
        "center_point": {
          "lat": 39.934408,
          "lon": -76.734529
        }
      }
    }
  ]
}
```

### Unpopulated Area

This ES query attempts to lookup an address in the middle of a desert and returns 0 results, which would trigger a fallback to WoF PiP:

```
GET pelias/address/_search
{
  "query": {
    "filtered": {
      "query": {
        "bool": {
          "must": []
        }
      },
      "filter": {
        "bool": {
          "must": [
            {
              "geo_distance": {
                "distance": "61m",
                "distance_type": "plane",
                "optimize_bbox": "indexed",
                "_cache": true,
                "center_point": {
                  "lat": 34.002955,
                  "lon": -106.726000
                }
              }
            },
            {
              "terms": {
                "source": [
                  "openaddresses",
                  "openstreetmap"
                ]
              }
            }
          ]
        }
      }
    }
  },
  "size": 1,
  "track_scores": true,
  "sort": [
    "_score",
    {
      "_geo_distance": {
        "order": "asc",
        "distance_type": "plane",
        "center_point": {
          "lat": 34.002955,
          "lon": -106.726000
        }
      }
    }
  ]
}
```