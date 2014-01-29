class Restaurant < ActiveRecord::Base
	def self.import_from_zomato(city_name)
		api_key = "7749b19667964b87a3efc739e254ada2"
		zomato = Zomato::Base.new(api_key)
		find_city = -> city {
			city.name == city_name
		}
		zomato_city = zomato.cities.find(&find_city)
		save_restaurant = -> restaurant {
			restaurant_object = new
			[:name,:address,:locality,:city,:cuisines,:rating_editor_overall,:cost_for_two,:has_discount].each do |property|
				restaurant_object[property] = restaurant.send(property)
			end
			restaurant_object.save
		}
		restaurants_in_locality = -> locality{
			locality.restaurants.restaurants.each(&save_restaurant)
		}
		zomato_city.localities.each(&restaurants_in_locality)
	end
end