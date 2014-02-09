class City < ActiveRecord::Base

	#Assosiations
	has_many :restaurants
	has_many :location_indices

end
