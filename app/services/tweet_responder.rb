class TweetResponder
	def initialize(username,query=nil,coordinates=[],cuisines=[])
		@url = "http://google.com"

		@username = username
		@query = query
		@coordinates = coordinates
		@cuisines = cuisines

		if text_query?
			@restaurants = Restaurant.native_language_search(@query)
			@restaurant = @restaurants.sample
		elsif location_query?
			@restaurants = LocationIndex.fastest_nearest_search(coordinates,cuisines,:instant)[:restaurants]
			@restaurant = @restaurants.sample
		else
			@restaurants = []
			@restaurant = nil
		end
	end

	def respond

		if no_matches?
			no_match_query_response_message
		elsif location_query?
			location_query_resonse_message
		elsif text_query?
			text_query_response_message.sample
		else
			error_query_response_message
		end

	end

	def no_matches?
		@restaurants.empty?
	end

	def text_query?
		@query.present?
	end

	def location_query?
		@coordinates.present? or @cuisines.present?
	end

private
	def text_query_response_message
		["Hey #{@username}, Checkout #{@restaurant.name} in #{@restaurant.address}"]
	end

	def location_query_resonse_message
		["Hey #{@username}, We've found #{@restaurants.count} awesome places to eat near you. Checkout out #{@restaurant.name}."]
	end

	def no_match_query_response_message
		["Hey #{@username}, Sorry we couldn't find any restaurants that match your description. Do visit our website. #{@url}"]
	end

	def error_query_response_message
		["Hey #{@username}, Do visit our website. #{@url}"]
	end
end