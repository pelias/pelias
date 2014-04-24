
var progress = require('progress-stream'),
    ProgressBar = require('progress');

var settings = {
  complete: '=',
  incomplete: ' ',
  width: 20,
  total: 0
};

module.exports = function(title, options){
  
  var bar = new ProgressBar(' ' + title + ' [:bar] :percent :etas', settings);

  var stat = progress({time:1000}, function(str){
    bar.total = str.length || options.length || 0;
    bar.tick( str.delta );
  });

  return stat;
}