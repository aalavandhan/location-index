(function(){
	var app = angular.module("rtHome");
	
	app.controller("rtHome.MainController",["$scope","rtRestaurant.Model","rtLocation","$anchorScroll","$location","rtXhrStateHandler",
    function($scope, Restaurant, locator, $anchorScroll, $location, XhrStateHandler){
    
      function defineScope(){

        $scope.xhrState = new XhrStateHandler()
        $scope.xhrState.setAllMessages(["Now!","Loading","Now!","Now!","Retry","Fatal"])
        $scope.xhrState.idle()

        $scope.Restaurant = Restaurant
        $scope.find = find

        $scope.dirty = false

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
        $scope.$apply()
        scrollToBottom()
      }

      function find(){
        $scope.dirty = true
        $scope.xhrState.initiate()

        locator.get()
          .then(function(coordinateString){
            
            Restaurant.executeQuery("location_query",{ coordinates: coordinateString })
              .then(function(response){
                $scope.xhrState.complete()
                scrollToBottom()

              },function(errors){
                $scope.xhrState.error()
                scrollToBottom()
              })

          }, showLocationError)
      }

      defineScope()

	  }

  ])

}())