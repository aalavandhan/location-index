class CustomZomato
	@@api_key = "7749b19667964b87a3efc739e254ada2"
	@@memory = {}

	def initialize
		@zomato = Zomato::Base.new(@@api_key)
	end

	def city (city_name)
		find_city = -> city {
			city.name == city_name
		}
		@zomato.cities.find(&find_city)
	end

	def has_city? (city_name)
		!city(city_name).nil?
	end

	def all_restaurants_in (city_name,&block)
		count = 0
		zomato_city = get_city(city_name)
		save_restaurant = -> restaurant{
			block.call(restaurant)
			count++
		}
		restaurants_in_locality = -> locality {
			locality.restaurants.restaurants.each(&save_restaurant)
		}
		zomato_city.localities.each(&restaurants_in_locality)
		update_memory(city_name,count)
	end

	def number_of_restaurants_in (city_name)
		@@memory[city_name]
	end

	private
		def update_memory(city_name,count)
			@@memory[city_name] = count if count > @@memory[city_name]
		end
end