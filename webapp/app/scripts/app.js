(function(){
  'use strict';
   var app = angular.module('rt', ['rtExplore',
   	 'rtHome',
   	 'rtSearch',
   	 'ngRoute'
   ]);

   app.config(['$routeProvider','$httpProvider',function($routeProvider,$httpProvider){
		  $routeProvider
		    .when('/home',{
		    	templateUrl: 'views/home.html',
		    	controller: 'rtHome.MainController'
		    })
		    .when('/search',{
		    	templateUrl: 'views/search.html',
		    	controller: 'rtSearch.MainController'
		    })
		    .otherwise({
		      redirectTo: '/home'
		  });

    }]);  

}());
