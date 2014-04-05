(function(){
  var app = angular.module("rtBase.services");
  app.service("rtResponseTransFormer",function(){
  	return{
  		transform : function(response){
        return response.data || response;
      }
  	}
  })
}());