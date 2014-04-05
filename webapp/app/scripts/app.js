(function(){
  'use strict';
   var app = angular.module('rt', ['rtExplore',
   	 'rtHome',
   	 'rtSearch',
   	 'ngRoute'
   ]);

   app.config(['$routeProvider',function($routeProvider){
		  $routeProvider
		    .when('/home',{
		    	templateUrl: 'views/home.html',
		    	controller: 'rtHome.MainController'
		    })
		    .otherwise({
		      redirectTo: '/home'
		    })
	  }]);

}());
