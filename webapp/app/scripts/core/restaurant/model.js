(function(){

	var app = angular.module("rtRestaurant");
  app.service("rtRestaurant.Model",["rtRestaurantFetcher","$q",
    function(restaurantFetcher, $q){

      var Restaurant = { }, _class = Restaurant;

      _class.collection = []

      _class.executeQuery = function(type,params){

        var deferred = $q.defer()

        restaurantFetcher.fetch(type,params).then(function(response){
          _class.loadCollection(response.data.restaurants)
          _class.emptyErrors()

          deferred.resolve(response,params)

        },function(errors){
          _class.emptyCollection()
          _class.loadErrors(errors)

          deferred.reject(errors)

        })

        return deferred.promise;
      } 

      _class.loadCollection = function(restaurants){
          this.collection = restaurants
      }

      _class.emptyCollection = function(){
          this.collection = []
      }

      _class.loadErrors = function(errors){
        this.errors = errors
      }

      _class.emptyErrors = function(){
        this.errors = []
      }      

      _class.hasErrors = function(){
        return !_.isEmpty( this.errors )
      }

      return Restaurant

    }
  ])

}())