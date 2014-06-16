
angular.module('play', []);

angular.module('play').directive('mapDemo', function () {

  'use strict';

  return {

    restrict: 'A',

    scope: {
      center: '='
    },

    link: function (scope, element) {

      scope.map = L.mapbox.map('map', 'randyme.gajlngfe', { zoomControl: false });
      new L.Control.Zoom({ position: 'bottomright' }).addTo(scope.map);

      scope.map.on('locationfound', function (e) { scope.map.fitBounds(e.bounds, { maxZoom: 15 }); });
      scope.map.locate();

      var move = false;
      scope.$watch('center', function () {
        if (!scope.center) { return; }
        if (move) {
          move = false;
          return;
        }
        move = true;
        scope.map.setView({ lat: scope.center.lat, lng: scope.center.lng }, 15);
      }, true);

      scope.map.on('moveend', function () {
        if (move) {
          move = false;
          return;
        }
        scope.$apply(function () {
          move = true;
          scope.center = scope.map.getCenter();
        });
      });

    }

  };

});

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
    },

    reverse: function (host, lng, lat, callback) {
      $http({ method: 'GET', url: host + '/reverse', params: { lng: lng, lat: lat } }).success(callback);
    }

  };

}]);

angular.module('play').controller('SearchCtrl', ['$scope', 'SearchService', function ($scope, SearchService) {

  'use strict';

  $scope.host = '//pelias.test.mapzen.com/'; // default

  $scope.fields = ['admin0', 'admin1', 'admin2', 'local_admin', 'locality', 'neighborhood', 'street', 'address', 'poi'];
  $scope.spec = {};

  $scope.fieldsFor = function (result) {
    var n = [];
    $scope.fields.forEach(function (f) { if (result.properties[f + '_name']) { n.push(f); } });
    return n;
  };

  $scope.$watch('[center.lat,center.lng]', function (center) {
    SearchService.reverse($scope.host, center[1], center[0], function (r) {
      $scope.spec.reverseResults = r.features;
    });
  }, true);

  $scope.goTo = function (result) {
    $scope.center.lng = result.geometry.coordinates[0];
    $scope.center.lat = result.geometry.coordinates[1];
    $scope.input = '';
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
