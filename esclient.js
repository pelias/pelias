
// @todo: this file requires a clean-up

var elasticsearch = require('elasticsearch'),
    Writable = require('stream').Writable;

var client = new elasticsearch.Client({
  apiVersion: '1.1',
  keepAlive: true,
  hosts: [{
    env: 'development',
    protocol: 'http',
    host: 'localhost',
    port: 9200
  }],
  log: [{
    type: 'stdio',
    level: [ 'error', 'warning' ]
  },{
    type: 'file',
    level: [ 'trace' ],
    path: 'esclient.log'
  }]
});

client.errorHandler = function(cb) {
  return function(err, data, errcode) {
    if(err && err.message) {
      return cb(err.message, data);
    }
    return cb(null, data);
  }
}

// streaming interface
client.stream = new Writable();

var buff = [];
var bufferMaxSize = 1000;
var insertedCount = 0;

// Flush buffer to ES
var flush = function(cb)
{
  console.log( 'writing %s records to ES', ( buff.length / 2 ), 'of', insertedCount );
  
  client.bulk({ body: buff }, function( err, resp ){
    // console.log( err, resp );
    insertedCount += ( buff.length / 2 );
    buff = []; // Reset buffer
    cb();
  });
}

client.stream._write = function (chunk, enc, next)
{
  var record = JSON.parse( chunk.toString() );
  
  buff.push({ index: {
    _index: record._index,
    _type: record._type,
    _id: record._id
  }}, record.data );
  
  // Buffer not full yet
  if( ( buff.length / 2 ) < bufferMaxSize ){
    return next();
  }

  flush(next);
};

client.stream.on( 'error', console.log.bind(console) );

client.stream.on( 'end', function(){
  flush( function(){
    console.log( 'finished writing data to ES' );
  });
});

module.exports = client;