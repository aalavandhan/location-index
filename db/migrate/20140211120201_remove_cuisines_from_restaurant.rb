class RemoveCuisinesFromRestaurant < ActiveRecord::Migration
  def change
  	remove_column :restaurants, :cuisines
  end
end
