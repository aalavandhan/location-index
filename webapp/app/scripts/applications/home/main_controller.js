(function(){
	var app = angular.module("rtHome");
	
	app.controller("rtHome.MainController",["$scope","rtRestaurant.Model","rtLocation","$anchorScroll","$location",

    function($scope, Restaurant, locator, $anchorScroll, $location){
    
      function defineScope(){
        $scope.Restaurant = Restaurant
        $scope.find = find
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
        locator.get()
          .then(Restaurant.executeLocationQuery)
          .then(function(response){
            scrollToBottom()
          },function(errors){
            scrollToBottom()
          })
      }

      defineScope()

	  }

  ])

}())