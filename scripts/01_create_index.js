var elasticsearch = require('elasticsearch');
var schema = require('../config/schema.json');
var client = new elasticsearch.Client();
client.indices.create({ index: 'pelias', body: schema });
