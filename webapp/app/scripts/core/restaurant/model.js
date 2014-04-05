(function(){
	var app = angular.module("rtRestaurant");
  app.service("rtRestaurant.Model",["$resource","rtResponseTransFormer","$q",function( $resource, transformer , $q ){
    var Restaurant = $resource("/api/search/text_query",{ }, { textQuery: { params : { query : 'query' }, method: 'GET' } }),
        _class = Restaurant;
    
    _class.doQuery = function( opts ){
      var deferred = $q.defer( );  
      _class.textQuery( opts.query, function( response ){
         deferred.resolve( transformer.transform( response ).restaurants );
    	},function( ){
         deferred.reject( );
    	});
    	return deferred.promise;
    };

    return Restaurant;

  }]);
}());