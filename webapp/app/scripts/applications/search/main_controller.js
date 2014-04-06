(function(){
	var app = angular.module("rtSearch")
	
	app.controller("rtSearch.MainController",["$scope","rtRestaurant.Model","$anchorScroll","$location","rtXhrStateHandler",
		function($scope, Restaurant, $anchorScroll, $location, XhrStateHandler){
    
	    function defineScope(){
        $scope.xhrState = new XhrStateHandler()
        $scope.xhrState.setAllMessages(["Now!","Loading","Now!","Now!","Retry","Fatal"])
        $scope.xhrState.idle()

        $scope.Restaurant = Restaurant	    	
        $scope.dirty = false

	    	$scope.find = find

        $scope.scrollToTop = scrollToTop	    	
	    }

      function scrollToBottom(){
        $location.hash('restaurants-list')
        $anchorScroll()
      }

      function scrollToTop(){
        $location.hash('hero')
        $anchorScroll() 
      }	    

	    function find(){
	    	$scope.dirty = true
	      $scope.xhrState.initiate()
    	  Restaurant.executeQuery("text_query",{ query: $scope.query })
					.then(function(response){
	          $scope.xhrState.complete()	          
	          scrollToBottom()
	        },function(errors){
	          $scope.xhrState.error()
	          scrollToBottom()
	        })
	    }

	    defineScope()

		}

	])

}())