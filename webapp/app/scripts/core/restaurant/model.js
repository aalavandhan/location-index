(function(){

	var app = angular.module("rtRestaurant");
  app.service("rtRestaurant.Model",["rtRestaurantFetcher","$q",
    function(restaurantFetcher, $q){

      var Restaurant = { }, _class = Restaurant;

      _class.collection = []

      _class.executeLocationQuery = function(coordinates,cuisines){

        var deferred = $q.defer(),
        params = { coordinates: coordinates, cuisines: cuisines };

        // shift to location query after testing
        restaurantFetcher.fetch("explore",params).then(function(response){
          _class.loadCollection(response.data.restaurants)
          _class.emptyErrors()

          deferred.resolve(response,coordinates,cuisines)

        },function(errors){
          _class.emptyCollection()
          _class.loadErrors(errors)

          deferred.reject(errors,coordinates,cuisines)

        })

        return deferred.promise;
      }

      _class.loadCollection = function(restaurants){
          _class.collection = restaurants
      }

      _class.emptyCollection = function(){
          _class.collection = []
      }

      _class.loadErrors = function(errors){
        _class.errors = errors
      }

      _class.emptyErrors = function(){
        _class.errors = []
      }      

      _class.hasErrors = function(){
        return !_.isEmpty( _class.errors )
      }

      return Restaurant

    }
  ])

}())