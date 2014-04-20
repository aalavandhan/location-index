class LocationIndex < ActiveRecord::Base

	#Each city is broken down into rectangular zones.The vertices of these zones are marked by 4 coordinats.
	#A coordinate is marked by latitude and longitude seperated by a comma.

	#A location index object consists of the location_index_id(:id), the 4 coordinates and a list of restaurants
	#in this this zone.

	#Constants

	@@buffer = 0.01
	#Defines the buffer added to the minimum and maximum latitude and longitude values

	@@zone_latitude_difference = 0.02
	#Defines the width of each zone

	@@zone_longitude_difference = 0.02
	#Defines the length of each zone

	#Assosiations
	belongs_to :city
	has_many :location_index_restaurants
	has_many :restaurants, :through => :location_index_restaurants

  #Geocoder
  reverse_geocoded_by :latitude, :longitude, :address => :full_address
  
  #Class Methods

  def self.index city_id
		self.create_zones_for city_id
		self.populate city_id
		self.update_restaurant_count city_id  	
  end

  #Update Restaurant Count for all indices in a city
  def self.update_restaurant_count city_id

		city = City.find(city_id)
  	return if not city.present?

  	LocationIndex.all.each do |index|
  		index.restaurant_count = index.restaurants.count
  		index.save
  	end
  end

  #Populates the Location Index for all restaurants in a city
  def self.populate city_id

  	city = City.find(city_id)
  	return if not city.present?

  	LocationIndexRestaurant.where(:location_index_id => city.location_indices.pluck(:id)).delete_all

  	city.restaurants.each do |restaurant|
  		index = locate(restaurant.coordinate_array,city.id)
			LocationIndexRestaurant.create(
					location_index_id: index.id,
					restaurant_id: restaurant.id
			) if index and restaurant.coordinate_array.present?
		end
	end

	#Creates latitude and longitude zones for particular city
  def self.create_zones_for city_id

  	#Check if the city is present in the list of cities
  	city = City.find(city_id)
  	return if not city.present?

  	#Remove previous indices for this city
  	city.location_indices.delete_all

  	range_of_latitudes,range_of_longitudes = self.zone_dimensions_for(city.id)

		#Iterate through the lists and zave the coordinates for each zone
		range_of_latitudes.each do |latitude|
			range_of_longitudes.each do |longitude|
				create(
					latitude_a:  latitude , 
					longitude_a: longitude ,
					latitude_b:  self.next_latitude(latitude),
					longitude_b: longitude,
					latitude_c:  latitude,
					longitude_c: self.next_longitude(longitude),
					latitude_d:  self.next_latitude(latitude),
					longitude_d: self.next_longitude(longitude),
					city_id: city.id
				)
			end
		end
	end

	#Retrives the maximum and minimum latitudes and longitudes for zone computation
	def self.zone_dimensions_for city_id

		city = City.find(city_id)
  	return if not city.present?

  	#Get a list of all restaurants in the city
		restaurants_in_city = Restaurant.where(city_id: city.id).where.not(latitude: 0, longitude: 0)

		#Find the maximum and minimum latitude and longitude points
		#based on city's bounds
		maximum_latitude = city.max_latitude
		minimum_latitude = city.min_latitude
		maximum_longitude = city.max_longitude
		minimum_longitude = city.min_longitude

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

		[range_of_latitudes,range_of_longitudes]
	end

	def self.locate(coordinates,city_id=nil)

		return nil if coordinates.nil? or coordinates.any?(&:nil?)

		query = "( latitude_d >= #{coordinates.first} and latitude_a <= #{coordinates.first} ) and " +
  					"( longitude_c >= #{coordinates.last} and longitude_b <= #{coordinates.last} ) "
  					
		query +=" and city_id = "+city_id.to_s if city_id.present?

  	where(query).first

  end

  def self.locate_by_locality(locality, city_id=nil)

  	return nil if locality.nil? or (locality.length < 5)
  	#Assuming average locality names are greater than 5 chars

  	query = "( full_address like '%#{locality}%')"
  	query +=" and city_id = "+city_id.to_s if city_id.present?

  	where(query)
  end

  def self.initialize_query_with(coordinates)
  	@query = { :restaurants => [] ,:errors => [] }
  	@query.merge!( :coordinates => coordinates )
  	@query.merge!( :step0 => false )
		@query.merge!( :step1 => false )
		@query.merge!( :step2 => false )
		@query.merge!( :step3 => false )
		@query.merge!( :step4 => false )
		@query
  end

	def self.fastest_nearest_search(coordinates,tags=nil,type=:complete,property=:rating_editor_overall,order=:desc,limit=10)
		initialize_query_with coordinates
		index = locate(coordinates)
		index.nil? ? (return @query.update(:step0 => false)) : @query.update(:step0 => true)
		@query = index.restaurants_in_zone(@query,tags,limit)
		@query = index.restaurants_in_near_by_zones(@query,tags,limit)
		return @query if ( type == :instant or @query[:restaurants].count > limit )
		@query = index.restaurants_in_city_with(@query,tags,limit) unless @query[:restaurants].present?
		return @query if @query[:restaurants].present?
		@query = index.restaurants_in_city_based_on(@query,property,order,limit) unless @query[:restaurants].present?
		return @query
	end

  #Instance Methods

	#Takes in [latitude,longitude] and checks if it lies within the zone
  def contains?(coordinate)
  	coordinate.first.between?(start_point.first,end_point.first) && coordinate.last.between?(start_point.last,end_point.last)
  end

  #Returns the center of the Zone(Location Index Object)
  def center
  	Geocoder::Calculations.geographic_center(to_a)
  end

  def latitude
  	center.first
  end

  def longitude
  	center.last
  end

  #Returns the four coordinates as an array
  def to_a
  	[:a,:b,:c,:d].map do |point|
  		[send("latitude_"+point.to_s),send("longitude_"+point.to_s)]
  	end
  end

  def to_string(point)
  	send("latitude_"+point.to_s).to_s+","+send("longitude_"+point.to_s).to_s
  end

  #Returns the adjacent zones to a location index object
  def near_by
		query = "(( latitude_a = #{latitude_b} and longitude_a = #{longitude_b} ) or " +
						"( latitude_a = #{latitude_c} and longitude_a = #{longitude_c} ) or " +
						"( latitude_a = #{latitude_d} and longitude_a = #{longitude_d} ) or " +
						"( latitude_b = #{latitude_a} and longitude_b = #{longitude_a} ) or " +
						"( latitude_b = #{latitude_c} and longitude_b = #{longitude_c} ) or " +
						"( latitude_b = #{latitude_d} and longitude_b = #{longitude_d} ) or " +
						"( latitude_c = #{latitude_a} and longitude_c = #{longitude_a} ) or " +
						"( latitude_c = #{latitude_b} and longitude_c = #{longitude_b} ) or " +
						"( latitude_c = #{latitude_d} and longitude_c = #{longitude_d} ) or " +
						"( latitude_d = #{latitude_a} and longitude_d = #{longitude_a} ) or " +
						"( latitude_d = #{latitude_b} and longitude_d = #{longitude_b} ) or " +
						"( latitude_d = #{latitude_c} and longitude_d = #{longitude_c} )) "

		query +=" and city_id = "+city.id.to_s

  	LocationIndex.where(query)
  end

	def restaurants_in_zone(query,tags,limit)
		restaurant_list = tags.present? ? self.restaurants.tagged_with(tags) : self.restaurants
		query[:step1] = restaurant_list.present?
		query[:restaurants] << restaurant_list.take(limit) if restaurant_list.present?
		query[:restaurants].flatten!
		query
	end

	def restaurants_in_near_by_zones(query,tags,limit)
		near_by_restaurants =  -> near_by_location_index {
			tags.present? ? near_by_location_index.restaurants.tagged_with(tags) :
											near_by_location_index.restaurants
		}
		restaurant_list = near_by.map(&near_by_restaurants)
		count = query[:restaurants].flatten.count
		query[:step2] = restaurant_list.present?
		query[:restaurants] << restaurant_list.take(limit - count) if restaurant_list.present?
		query[:restaurants].flatten!
		query
	end

	def restaurants_in_city_with(query,tags,limit)
		restaurant_list = self.city.restaurants.tagged_with(tags) if tags.present?
		count = query[:restaurants].flatten.count
		query[:step3] = restaurant_list.present?
		query[:restaurants] << restaurant_list.take(limit - count) if restaurant_list.present?
		query[:restaurants].flatten!
		query
	end

	def restaurants_in_city_based_on(query,property,order,limit)
		count = query[:restaurants].flatten.count
		restaurant_list = self.city.restaurants.order(property, order).take(limit - count)
		query[:step4] = (restaurant_list.present?)
		query[:restaurants] << restaurant_list if restaurant_list.present?
		query[:restaurants].flatten!
		query
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
	  def self.to_array(coordinate_string)
	  	coordinate_array = coordinate_string.split(",")
	  	[ coordinate_array.first.to_f , coordinate_array.last.to_f ]
	  end

	  #Returns an array from minimum to maximum with specified interval
  	def self.range(minimum,maximum,interval)
	  	minimum.step(maximum,interval).to_a
	  end

	  #Instance Methods

	  #Returns the starting point of the zone
	  def start_point
	  	to_a.min
	  end

		#Returns the ending point of the zone
	  def end_point
	  	to_a.max
	  end
end