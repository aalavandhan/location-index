(function(){
  var app = angular.module("rtBase.services");
  app.service("rtLocation",["$q",
    function($q){

    	return {
      		get : function(){
            var deferred = $q.defer( )

      			if(navigator.geolocation){
      				navigator.geolocation.getCurrentPosition(function(position){
                var coordinateString = [position.coords.latitude, position.coords.longitude].join(",")
                deferred.resolve(coordinateString)
              },function(){
                deferred.reject()  
              })
      			}else{
      				deferred.reject()
      			}

            return deferred.promise
          }
      	}
      }

  ])

}())