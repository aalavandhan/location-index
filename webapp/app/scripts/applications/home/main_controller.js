(function(){
	var app = angular.module("rtHome");
	
	app.controller("rtHome.MainController",["$scope","rtRestaurant.Model","rtLocation","$anchorScroll","$location","rtXhrStateHandler",
    function($scope, Restaurant, locator, $anchorScroll, $location, XhrStateHandler){
    
      function defineScope(){
        $scope.limit = 25

        $scope.xhrState = new XhrStateHandler()
        $scope.xhrState.setAllMessages(["Now!","Loading","Now!","Now!","Retry","Fatal"])
        $scope.xhrState.idle()

        $scope.Restaurant = Restaurant
        $scope.find = find

        $scope.dirty = false
        $scope.locationQuery = true

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

      function showLocationError(){
        Restaurant.loadErrors("We were unable to get you location")
        scrollToBottom()
      }

      function getResults(coordinateString){
        Restaurant.executeQuery("location_query",{ coordinates: coordinateString, cuisines: $scope.cuisines, limit: $scope.limit })
              .then(function(response){
                $scope.Restaurant.loadCollection(response.data.restaurants)
                $scope.Restaurant.emptyErrors()
                $scope.xhrState.complete()
                $scope.response = _.omit(response, "data","errors")
              },function(errors){
                $scope.Restaurant.emptyCollection()
                $scope.Restaurant.loadErrors(errors)
                $scope.xhrState.error()
              })
      }

      function find(){
        $scope.dirty = true
        $scope.xhrState.initiate()
        scrollToBottom()
        if($scope.state == 'auto'){
          locator.get().then(getResults, showLocationError)
        }else{
          var coordinateString = [$scope.coordinates.latitude, $scope.coordinates.longitude].join(",")
          getResults(coordinateString)
        }

      }

      defineScope()

	  }

  ])

}());