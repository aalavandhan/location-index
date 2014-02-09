class Restaurant < ActiveRecord::Base

	#Assosiations
	belongs_to :city

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

	def coordinates
	latitude.to_s + "," + longitude.to_s
	end
	
end