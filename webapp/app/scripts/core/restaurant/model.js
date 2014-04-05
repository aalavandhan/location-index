(function(){
	var app = angular.module("rtRestaurant");
  app.service("rtRestaurant.Model",["$resource",function($resource){
    var Restaurant = $resource("/api/search/text_query",{ }, { textQuery: { params : { query : 'query' }, method: 'GET', isArray: true } }),
        _class = Restaurant;

    return Restaurant;

  }]);
}());