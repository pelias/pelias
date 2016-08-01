# Categories Filter

We need to add the ability to search for records in specific categories.
Categories need to be mapped from original data sources into a common taxonomy.

## Proposed Functionality

### `/search` & `/autocomplete`

##### Functionality
- Add new filter parameter called `categories`
- The filter should accept either a single value or a comma separated list of values
- When multiple values are provided, the filter should be an **OR** and records with any one of the values should be returned

> :information_source: *User MUST provide `text` for the `/search` endpoint. To perform a categories search without `text`, the user should employ `/reverse`.*

##### Validation
Here are examples and possible acceptance tests to validate this feature.
Repeat all queries for `/autocomplete` as well.

Use of `categories` + `text`

`/v1/search?categories=food&text=Didi`

> DiDi Dumpling, Manhattan, New York, NY, USA


Use of `categories` + `text` + `focus`

`/v1/search?categories=food&text=Didi&focus.point.lon=-73.984537&focus.point.lat=40.740134`

> DiDi Dumpling, Manhattan, New York, NY, USA


Use of `categories` alone

`/v1/search?categories=food,health`

> error due to missing text param. inform user to switch to /reverse for such queries


### `/nearby`

##### Functionality
- Brand new endpoint to represent what `/reverse` used to be and allow for various filters
- Different from `/search` and `/autocomplete` in that it does not require a `text` parameter
- Only required parameter is `point`
- Supports a filter parameter called `categories`
- The filter should accept either a single value or a comma separated list of values
- When multiple values are provided, the filter should be an **OR** and records with any one of the values should be returned

##### Validation

Use of `categories` + `point`

`/v1/nearby?categories=health&point.lon=-73.984537&point.lat=40.740134`

> pharmacies near focus point



Use of `categories` list + `point`

`/v1/nearby?categories=health,food&point.lon=-73.984537&point.lat=40.740134`

> pharmacies AND restaurants near focus point


### Exceptions and Error Conditions
It seems like a good idea to help users recognize they've made a mistake, and users are more likely to recognize a mistake if you send back an error instead of a warning. Warnings most often don't get many eyeballs on them.
So in a lot of the cases below, errors will be returned and the queries will fail.

##### blank value
If `categories` parameter is left blank, an error should be returned to indicate that the query could not be performed as requested.

##### invalid value
If `categories` parameter contains a single invalid category value an error should be returned to indicate that the query could not be performed as requested.

##### single blank value in a list of many valid values
If `categories` parameter looks something like `categories=food,  ,health`, an error should be returned to indicate that the query could not be performed as requested.

##### single invalid value in a list of many valid values 
If `categories` parameter contains an invalid non-empty value in a list of other valid values, a warning should be returned in the geojson that the invalid category will be ignored. Query should be performed using only the valid categories.

##### list of invalid values
If `categories` parameter contains only invalid non-empty values, an error should be returned to indicate that the query could not be performed as requested.

## General Questions
- *Consider using `kind` instead of `categories` to match the vector-tiles and WOF terminology. To indicate that the parameter is a list, would we then use `kinds`? That sounds funny.*
- *Would it make more sense to add a new endpoint that allows for `categories` and `focus`. Possibly call it `/nearby`? Overloading `/reverse` doesn't feel very appropriate.*
