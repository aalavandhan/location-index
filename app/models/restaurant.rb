class Restaurant < ActiveRecord::Base

	#Associations
	belongs_to :city

	has_one :location_index_restaurant
	has_one :location_index, :through => :location_index_restaurant

	#Tags
  acts_as_taggable
  acts_as_taggable_on :cuisines

  #Geocoder
  geocoded_by :address

	#Class Methods

	#Takes in a name of a city and retrives all the restaurants in that city via the zomato API
	#Note that city_name should be a valid name which is supported by zomato

	#Class Methods

	def self.import_from_zomato(city_name)

		#Get all restaurants in the given city form zomato
		CustomZomato.new.all_restaurants_in(city_name) do |restaurant|

			#Build the restaurant object
			restaurant_object = new

			#A restaurant object has the following fields
			[:name,:address,:locality,:rating_editor_overall,:cost_for_two,:has_discount].each do |property|
				restaurant_object[property] = restaurant.send(property)
			end

			#A restaurant object belongs_to a city
			restaurant_object.city_id = City.where( :name => restaurant.city ).first_or_create.id

			#A restaurant object also has a list of cusines it serves
			restaurant_object.cuisine_list = restaurant.cuisines

			#Save the created object
			restaurant_object.save
		end
	end

	def self.native_language_search(query)
		parsed_query = QueryParser.new(query).parsed_query

		cities = City.where(:name => parsed_query[:cities]) if parsed_query[:cities]
		localities = LocationIndex.where(:locality => parsed_query[:localities]) if parsed_query[:localities]

		if localities.present?			
			restaurants = Restaurant.where(:id => LocationIndexRestaurant.where(:location_index_id => localities.pluck(:id)).pluck(:restaurant_id))
		elsif cities.present?
			restaurants = Restaurant.where(:city_id => cities.pluck(:id))
		else
			restaurants = Restaurant.order(:rating_editor_overall => :desc).limit(50)
		end

		restaurants = restaurants.tagged_with(parsed_query[:cuisines]) if parsed_query[:cuisines].present?

		query = " 1 < 2 "

		query += " and (rating_editor_overall = #{parsed_query[:rating]}) " if parsed_query[:rating]
		query += " and (cost_for_two = #{parsed_query[:maximum_cost]}) "    if parsed_query[:maximum_cost]
		query += " and (has_discount) "    if parsed_query[:has_discount]

		restaurants.where(query)
	end	

	#Instance Methods

	#Calucates the distance between a [latitude,longitude] and a restaurant in Kilometers.
	#(eg) Geocoder::Calculations.distance_between([47.858205,2.294359], [40.748433,-73.985655])
	#returns distance in miles
	def distance_from(coordinate_array)
	 	super * Constant.miles_per_kilo_meter
	end

	#Returns a list of restaurants which are within the specified radius
	def nearbys(distance_in_kms)
		super(distance_in_kms / Constant.miles_per_kilo_meter)
	end

	#Returns the latitude and longitude as a comma seperated string
	def coordinates
	 coordinate_array.map(&:to_s).join(",")
	end

	def coordinates=(new_coordinates)
		self.latitude = new_coordinates.split(",").first.to_f
		self.longitude = new_coordinates.split(",").last.to_f
	end

	#Retuns the latitude and longitude as an array
	def coordinate_array
		[latitude,longitude]
	end
	
end