(function(){

	var app = angular.module("rtRestaurant");
  app.service("rtRestaurant.Model",["rtRestaurantFetcher","$q",
    function(restaurantFetcher, $q){

      var Restaurant = { }, _class = Restaurant;

      _class.collection = []

      _class.executeQuery = function(type,params){

        var deferred = $q.defer()

        return restaurantFetcher.fetch(type,params);

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

      _class.count = function(){
        return (_class.collection) ? _class.collection.length : 0
      }

      return Restaurant

    }
  ])

}());