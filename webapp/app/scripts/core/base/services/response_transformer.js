(function(){

  var app = angular.module("rtBase.services")

  app.service("rtResponseTransFormer",["$q",
  	function($q){
	  	return{
	  		transform : function(response){
	  			var deferred = $q.defer( )

	  			if(response.api_response)
		  			(response.success == 1) ? deferred.resolve(response) : deferred.reject(response.errors)
	  			else
  					deferred.resolve(response)

	        return deferred.promise
	      }
	  	}
  	}
	])

}());