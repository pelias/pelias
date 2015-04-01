## Things we've learned (the hard way)

##### 03/2015

1. Popularity in quattroshapes are unreliable and not consistent. 
2. Popularity and population cannot be aggregated to all records contained in an admin area
(for example: a point in SoHo shouldnt get population or popularity of soho)
3. It may be useful to add a field called admin_popularity that’d contain aggregated popularity value
from vaious admins that the point belongs to
4. Using popularity from quattroshapes for just the centroids of shapes could help boost popular
neighborhoods higher than others https://github.com/pelias/quattroshapes-pipeline/issues/20
5. Use featureClass/ featureCode to make sure admin boundaries (town, city, state, country etc)
from geonames has the right admin names from admin_lookup. Further, we should explore featureClass and
featureCode more and use it in conjunction with category stuff that @PeliasPete is working on..
https://github.com/pelias/geonames/issues/20
