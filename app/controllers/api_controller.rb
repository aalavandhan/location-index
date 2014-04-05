class ApiController < ApplicationController

	#before_filter :authorize!, :except => [:tweet]
	before_filter :authorize_admin!, :only => [:tweet]

	def text_query
		@restaurants = Restaurant.native_language_search(query_from_params)
		respond_with_CRUD_json_response_for_collection(@restaurants)
	end

	def location_query
		response = LocationIndex.fastest_nearest_search(coordinates_from_params,cuisines_from_params,:instant)
		@restaurants = response[:restaurants]
		respond_with_CRUD_json_response_for_collection(@restaurants, response.except(:restaurants,:errors), response[:errors])
	end

	def explore
		@restaurants = Restaurant.all
		respond_with_CRUD_json_response_for_collection(@restaurants)
	end

	def tweet
		responder = TweetResponder.new(username_params,query_from_params,coordinates_from_params,cuisines_from_params)
		twitter = TwitterWrapper.new
		@response = twitter.client.update(responder.respond)
		respond_with_CRUD_json_response(true)
	end

private
	def coordinates_from_params
		params[:coordinates].split(",") if params[:coordinates]
	end

	def cuisines_from_params
		params[:cuisines].split(",") if params[:cuisines]
	end

	def query_from_params
		params[:query]
	end

	def username_params
		params[:username]
	end

end
