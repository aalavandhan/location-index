class GraphController < ApplicationController
	def show
		@city = City.find_by_name(params[:city_name])
		@indices = @city.location_indices.map(&:restaurant_count)
		@dimensions = LocationIndex.zone_dimensions_for(@city.id).map(&:count)
	end
	def detail
		@city = City.find_by_name(params[:city_name])
		@location_index = map_zone_id_to_location_index
		redirect_to root_path if not @location_index 
	end
	private
		def map_zone_id_to_location_index
			zone_id = params[:zone_id].to_i
			@city.location_indices.all[zone_id]
		end
end