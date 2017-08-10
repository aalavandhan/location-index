class City < ActiveRecord::Base

	#Assosiations
	has_many :restaurants, :dependent => :destroy
	has_many :location_indices, :dependent => :destroy
	has_many :location_index_restaurants, :through => :location_index, :dependent => :destroy
	
	def max_latitude
		bound_by.map(&:first).max
	end

	def min_latitude
		bound_by.map(&:first).min
	end

	def max_longitude
		bound_by.map(&:last).max
	end

	def min_longitude
		bound_by.map(&:last).min
	end

	def bound_by
		split_pair = -> pair {
			pair.split(":")
				.map(&:to_f)
		}
		bounds.split(",").map(&split_pair)
	end

	def contains? latitude, longitude
		latitude.between?(bound_by.first.first,bound_by.last.first) and
				longitude.between?(bound_by.first.last,bound_by.last.last)
	end

end
