class ApiController < ApplicationController

	#before_filter :authorize!, :except => [:tweet]
	before_filter :authorize_admin!, :only => [:tweet]

	before_filter :start_timer

	def text_query
		@restaurants = Restaurant.native_language_search(query_from_params)
		respond_with_CRUD_json_response_for_collection(@restaurants)
	end

	def location_query
		response = LocationIndex.fastest_nearest_search(coordinates_from_params,cuisines_from_params,:complete,:rating_editor_overall,:desc, limit_params)
		@restaurants = response[:restaurants]

		response[:closest] = response[:restaurants].min_by { |restaurant| restaurant.distance_from(coordinates_from_params) }
		
		response[:closest_distance] = response[:closest].distance_from(coordinates_from_params) if response[:closest]

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
		params[:coordinates].present? ? params[:coordinates].split(",") : []
	end

	def cuisines_from_params
		params[:cuisines].present? ? params[:cuisines].split(",") : nil
	end

	def query_from_params
		params[:query]
	end

	def username_params
		params[:username]
	end

	def limit_params
		params[:limit].to_i
	end	

	def start_timer
		@start_time = Time.now
	end

end
