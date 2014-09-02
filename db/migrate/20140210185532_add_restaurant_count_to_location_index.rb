class AddRestaurantCountToLocationIndex < ActiveRecord::Migration
  def change
  	add_column :location_indices, :restaurant_count, :integer
  end
end
