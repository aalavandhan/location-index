(function(){

  var app = angular.module("rtRestaurant")

  app.service("rtRestaurantFetcher",["$q","$http","rtResponseTransFormer",
    function($q, $http, transformer){
      return{
        fetch : function(queryType,params){

          var deferred = $q.defer(),
          baseUrl = "/api/search/";
          
          $http({method: 'GET', url: baseUrl + queryType, params: params })
          
            .success(function(data){
              transformer.transform(data).then(function(response){

                deferred.resolve(response,params)

              },function(errors){

                deferred.reject(errors,params)

              })
            })

            .error(function(data){
              deferred.reject(data)
            })

          return deferred.promise
        }
      }
    }
  ])

}());