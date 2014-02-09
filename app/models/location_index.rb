class LocationIndex < ActiveRecord::Base

	#Each city is broken down into rectangular zones.The vertices of these zones are marked by 4 coordinats.
	#A coordinate is marked by latitude and logitude seperated by a comma.

	#A location index object consists of the location_index_id(:id), the 4 coordinates and a list of restaurants
	#in this this zone.

	#Constants

	@@buffer = 0.01						
	#Defines the buffer added to the minimum and maximum latitude and longitude values

	@@zone_latitude_difference = 0.275
	#Defines the width of each zone

	@@zone_longitude_difference = 0.085
	#Defines the length of each zone

	#Assosiations
	belongs_to :city

	#Tags
	acts_as_taggable 
  acts_as_taggable_on :restaurants

  #Class Methods

  #Populates the Location Index for all restaurants in a city
  def self.populate city

  	#Check if the city is present in the list of cities
  	city = City.find_by_name(city)
  	return if not city.present?

  	#Remove previous indices for this city
  	LocationIndex.where(city_id: city.id).map(&:delete)

  	#Get a list of all restaurants in the city
		restaurants_in_city = Restaurant.where(city_id: city.id).where.not(latitude: 0, longitude: 0)

		#Find the maximum and minimum latitude and longitude points
		#amoung all restaurants in the city
		maximum_latitude = restaurants_in_city.maximum(:latitude)
		minimum_latitude = restaurants_in_city.minimum(:latitude)
		maximum_longitude = restaurants_in_city.maximum(:longitude)
		minimum_longitude = restaurants_in_city.minimum(:longitude)

		#Finds the maximum and minimum latitude and longitude points
		#with a predefined buffer
		minimum_latitude_with_buffer = minimum_latitude - @@buffer
		maximum_latitude_with_buffer = maximum_latitude + @@buffer
		minimum_longitude_with_buffer = minimum_longitude - @@buffer
		maximum_longitude_with_buffer = maximum_longitude + @@buffer

		#Obtain Latitude and longitude ranges as array form specitied
		#minimum to maximum
		range_of_latitudes = self.range( minimum_latitude_with_buffer , maximum_latitude_with_buffer , @@zone_latitude_difference)
		range_of_longitudes = self.range( minimum_longitude_with_buffer , maximum_longitude_with_buffer , @@zone_longitude_difference)

		#Iterate through the lists and zave the coordinates for each zone
		range_of_latitudes.each do |latitude|
			range_of_longitudes.each do |longitude|
				create(
					coordinate_a: self.to_string( latitude , longitude ),
					coordinate_b: self.to_string( self.next_latitude(latitude) , longitude ),
					coordinate_c: self.to_string( latitude , self.next_longitude(longitude) ),
					coordinate_d: self.to_string( self.next_latitude(latitude) , self.next_longitude(longitude) ),
					city_id: city.id
				)
			end
		end

	end

  #Instance Methods

  #Returns the center of the Zone(Location Index Object)
  def center
  	Geocoder::Calculations.geographic_center(to_a)
  end

  #Takes in any one of ["a","b","c","d"] and returns the currsponding latitude
  def latitude(coordinate)
  	send("coordinate_"+coordinate.to_s).split(",").first.to_f
  end

  #Takes in any one of ["a","b","c","d"] and returns the currsponding longitude
  def longitude(coordinate)
  	send("coordinate_"+coordinate.to_s).split(",").last.to_f
  end

  #Returns the four coordinates as an array
  def to_a
  	[:a,:b,:c,:d].map do |point|
  		send("coordinate_"+point.to_s).split(",").map(&:to_f)
  	end
  end 

  private

  	#Class Methods

  	#Takes in a latitude and returns the next_latitude based on defined zone_difference
	  def self.next_latitude(latitude)
	  	latitude + @@zone_latitude_difference
	  end

	  #Takes in a longitude and returns the next_longitude based on defined zone_difference
	  def self.next_longitude(longitude)
	  	longitude + @@zone_longitude_difference
	  end

		#Takes latitude and longitude in float at returns a coordinate string
	  def self.to_string(latitude,longitude)
	  	latitude.to_s + "," + longitude.to_s
	  end

		#Takes in a coordinate string and returns latitude and longitude in float
	  def self.to_array(coordinate)
	  	[ coordinate.split(",").first.to_f , coordinate.split(",").last.to_f ]
	  end

	  #Returns an array from minimum to maximum with specified interval
  	def self.range(minimum,maximum,interval)
	  	minimum.step(maximum,interval).to_a
	  end

end