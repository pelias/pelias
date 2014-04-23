var fs = require('fs');
var request = require('request');
var unzip = require('unzip');
var elasticsearch = require('elasticsearch');
var csv = require('csv');

function buildJson(row) {
  return { _id: row[0], data: { name: row[1] } };
}

function jsonifyGeonames() {
  var geonames = [];
  var group_count = 1000;
  var group_size = 1000;
  csv()
    .from.path('data/geonames/allCountries.txt', { delimiter: '\t' })
    .to.stream(fs.createWriteStream('data/geonames/allCountries.json'))
    .transform( function(row, index) {
      if (index < group_count) {
        geonames.push(buildJson(row));
      } else {
        group_count += group_size;
        var geonames_group = geonames;
        geonames = [];
        return JSON.stringify(geonames_group) + "\n";
      }
    });
}

function unzipGeonames() {
  fs.createReadStream('data/geonames/allCountries.zip')
    .pipe(unzip.Extract({ path: 'data/geonames' }))
    .on('close', jsonifyGeonames);
}

function downloadGeonames() {
  request('http://download.geonames.org/export/dump/allCountries.zip')
    .pipe(fs.createWriteStream('data/geonames/allCountries.zip'))
    .on('close', unzipGeonames);
}

if (!fs.existsSync('data/geonames/allCountries.zip')) {
  downloadGeonames();
} else {
  unzipGeonames();
}
