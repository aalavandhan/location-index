angular.module("rtBase.directives")

.constant('DEFAULT', {
	latitude : 13.044750091887865,
	longitude : 80.25,
	zoom : 2,
	mapTypeId : google.maps.MapTypeId.ROADMAP,
	binding : "coordinates"
})

.directive('mapCanvas',["DEFAULT", function(DEFAULT){
	return {
		restrict: 'E',
    replace: 'true',
		template : "<div id=\"map_canvas\"></div>",
		link : function(scope, elem, attrs) {

			var latitude = attrs.mapMarketInitialLatitude || DEFAULT.latitude
			var longitude = attrs.mapMarketInitialLongitude || DEFAULT.longitude
			var zoom = parseInt(attrs.mapZoom) || DEFAULT.zoom
			var binding = attrs.mapBinding || DEFAULT.binding

      var mapCoordinates = new google.maps.LatLng(latitude, longitude)

	    var mapOptions = {
	      zoom: zoom,
	      center: mapCoordinates,
	      mapTypeId: DEFAULT.mapTypeId
	    }

	    var map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions)
	    
	    var marker = new google.maps.Marker({
	        position: mapCoordinates, 
	        map: map,
	        draggable: true
	    })

	    var resetCoordinates = function(){
	    	scope[binding] = {
    			latitude : marker.position.lat(),
    			longitude : marker.position.lng()
    		}
	    }

	    google.maps.event.addListener(marker, 'drag', function(){
    		resetCoordinates()
      })

	    resetCoordinates()
    }
	}
}])
