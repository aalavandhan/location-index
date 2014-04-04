class CustomZomato

	#A Custom wrapper for the zomato gem

	attr_accessor :zomato

	#Constants

	#API key for zomato gem
	@@api_key = "7749b19667964b87a3efc739e254ada2"

	#Memoization, to prevent unnecessary API calls
	@@memory = {}

	#Instance Methods
	
	#Create a zomato instance
	def initialize
		@zomato = Zomato::Base.new(@@api_key)
	end

	#Get a zomato city instance
	def city(city_name)
		find_city = -> city {
			city.name == city_name
		}
		@zomato.cities.find(&find_city)
	end

	#Check if city_name supported by zomato
	def has_city?(city_name)
		city(city_name).present?
	end

	#Retrive all restaurants for a valid city_name
	#Takes in a block for custom processing of each restaurant
	def all_restaurants_in (city_name,&block)
		count = 0
		@@memory[city_name] = {} if @@memory[city_name].nil?
		
		return if (!has_city?(city_name)) || @@memory[city_name][:updated]
		
		zomato_city = city(city_name)

		save_restaurant = -> restaurant {
			block.call(restaurant)
			count = count + 1
		}
		
		restaurants_in_locality = -> locality {
			locality.restaurants.restaurants.each(&save_restaurant)
		}
		
		zomato_city.localities.each(&restaurants_in_locality)
		update_memory(city_name,count)
	end

	#Returns the number of restaurants in a city form computed cache
	def number_of_restaurants_in (city_name)
		@@memory[city_name][:count] || nil
	end

	def updated? (city_name)
		@@memory[city_name][:updated]
	end

	private
		def update_memory(city_name,count)
			@@memory[city_name] ||= {}
			@@memory[city_name][:updated] = true
			@@memory[city_name][:count] = count if count > @@memory[city_name][:count].to_i
		end
end