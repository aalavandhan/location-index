class AddCityReferenceToRestaurant < ActiveRecord::Migration
  def change
  	add_reference :restaurants, :city
  end
end
