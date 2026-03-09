# Ballina Shire Council Address Data Issue - Resolution Guide

## Issue Description

Users searching for addresses in Ballina, NSW, Australia were seeing incorrect suburb names returned. For example, searching for "40 Cherry Street, Ballina, NSW" would return results showing "West Ballina" as the suburb instead of "Ballina".

## Root Cause

The Who's on First (WOF) locality data for Ballina had incorrectly listed "West Ballina" as an alternative name (synonym), which caused the geocoder to associate addresses with the wrong locality.

## Resolution

The issue was fixed in the [whosonfirst-data/whosonfirst-data-admin-au](https://github.com/whosonfirst-data/whosonfirst-data-admin-au) repository via [PR #49](https://github.com/whosonfirst-data/whosonfirst-data-admin-au/pull/49):

- Removed "West Ballina" from `name:eng_x_preferred` 
- Removed "W Ballina" from `name:eng_x_variant`

## What Users Need to Do

If you're running a self-hosted Pelias instance and still seeing incorrect Ballina addresses:

1. **Re-import your Who's on First data**: Re-run the Who's on First importer to get the updated locality data
2. **Refresh all data sources**: Consider re-importing all data sources to ensure consistency

### Commands to Update Data

```bash
# Re-import Who's on First data
docker run --rm -e Pelias_WOF_PROTOCOL=https -e Pelias_WHOISONFIRST_HOST=whosonfirst-data -e Pelias_WHOISONFIRST_MAPZEN_API_KEY=your_key pelias/wof --help

# Or use the Pelias docker-compose to re-import
cd pelias/docker
docker-compose run --rm api
```

## Additional Resources

- [Who's on First Data for Australia](https://github.com/whosonfirst-data/whosonfirst-data-admin-au)
- [Pelias Data Import Documentation](https://github.com/pelias/documentation)
- [OpenAddresses Australian Data Sources](https://github.com/openaddresses/openaddresses/tree/master/sources/au)

## Related Issues

- [Pelias Issue #987: Mapzen Address search showing incorrect addresses for Ballina Shire Council](https://github.com/pelias/pelias/issues/987)
