
Design proposal and implementation notes for the `Alt-Names and Internationalization` feature outlined in the milestone definition document.

## geojson changes

we will aim for no changes to the response document, with the exception that the admin fields will return strings from a different language when requested.

the label generation logic will remain unchanged, although their content will change according to the requested language.

```
{
  "type": "Feature",
  "geometry": {
    "type": "Point",
    "coordinates": [
      13.014022,
      47.880277
    ]
  },
  "properties": {
    "id": "101786767",
    "gid": "whosonfirst:locality:101786767",
    "layer": "locality",
    "source": "whosonfirst",
    "source_id": "101786767",
    "name": "Anthering",
    "confidence": 0.6,
    "match_type": "fallback",
    "accuracy": "centroid",
    "country": "Austria",
    "country_gid": "whosonfirst:country:85632785",
    "country_a": "AUT",
    "region": "Salzburg",
    "region_gid": "whosonfirst:region:85681681",
    "county": "Salzburg - Umgebung",
    "county_gid": "whosonfirst:county:102049799",
    "locality": "Anthering",
    "locality_gid": "whosonfirst:locality:101786767",
    "label": "Anthering, Austria"
  },
  "bbox": [
    13.0046106354,
    47.8763406752,
    13.0220752065,
    47.8860466802
  ]
}
```

## schema changes

```
"parent": {
  "type": "object",
  "dynamic": true,
  "properties": {
    "country": {
      "type": "string",
      "analyzer": "peliasAdmin",
      "store": "yes"
    },
    "country_a": {
      "type": "string",
      "analyzer": "peliasAdmin",
      "store": "yes"
    },
    "country_id": {
      "type": "string",
      "analyzer": "keyword",
      "store": "yes"
    }

...
```

```
"parent": {
  "type": "object",
  "properties": {
    "country_id": {
      "type": "integer",
      "analyzer": "not_analyzed",
      "store": "yes"
    }

...
```

removing the string fields from the mapping will greatly reduce the index size, unfortunately will not be able to remove these in the first iteration as the autocomplete endpoint and structured endpoint will rely on those fields being present in the index.

additionally, changing the `{admin}_id` property from 'string/keyword' to 'integer/not_analyzed' will result in using significantly less disk and will likely speed up query execution.

discuss: it might be possible to change this setting now as it is not currently being used to search on? maybe with the exception of `/place`?

```
https://www.elastic.co/guide/en/elasticsearch/reference/current/number.html
long: 64 bit
integer: 32 bit
```

## parser changes

parser needs to produce a list of potential id filters and split the remainder of the tokens out for address parsing.
we will probably need a parser test suite and a fallback parsing strategy

this will only apply to `/search` for the initial iteration

## query changes

the query logic will need to be changed, instead of performing full text queries for the admin hierarchy we only filter on id.

due to maintaining the schema for legacy we will need to do string matching on the id fields rather than numeric matching, this can be improved at a later date once the autocomplete parsing functionality has been completed.

## admin name service

a service will need to be created which is able to return the `name:*` value depending on the requested language. it's likely that the parsing service can be reused for this purpose as it already contains that data in it's indexes.

## request changes

we will need to store the requested language in the request object so that the middleware can use it later. some validation will need to be performed in order to check that a valid language has been selected. optionally an error or warning can be produced here.

## response changes

the response documents will contain the ids of the admin records, for each document we will use the appropriate name depending on the requested language. int he case where the language is not available we will fallback to another language (english).
