class LocationIndexRestaurant < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :location_index
end
