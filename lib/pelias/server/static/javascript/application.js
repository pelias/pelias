
angular.module('play', []);

angular.module('play').directive('focus', function () {

  'use strict';

  return {

    link: function (scope, element) {
      setTimeout(function () { element[0].focus(); }, 1);
    }

  };

});

angular.module('play').service('SearchService', ['$http', function ($http) {

  'use strict';

  return {

    search: function (host, query, callback) {
      $http({ method: 'GET', url: host + '/search', params: { query: query } }).success(callback);
    },

    suggest: function (host, query, callback) {
      $http({ method: 'GET', url: host + '/suggest', params: { query: query } }).success(callback);
    }

  };

}]);

angular.module('play').controller('SearchCtrl', ['$scope', 'SearchService', function ($scope, SearchService) {

  'use strict';

  $scope.host = 'http://pelias.test.hnd.mapzen.com/'; // default

  $scope.fields = ['admin0', 'admin1', 'admin2', 'local_admin', 'locality', 'neighborhood', 'street', 'address', 'poi'];

  $scope.fieldsFor = function (result) {
    var n = [];
    $scope.fields.forEach(function (f) { if (result.properties[f + '_name']) { n.push(f); } });
    return n;
  };

  $scope.searchResults = [];
  $scope.suggestResults = [];
  $scope.$watch('input', function (input) {
    if (input) {
      SearchService.search($scope.host, input, function (d) { $scope.searchResults = d.features; });
      SearchService.suggest($scope.host, input, function (d) { $scope.suggestResults = d.features; });
    } else {
      $scope.searchResults.length = $scope.suggestResults.length = 0;
    }
  });

}]);
