class CreateLocationIndexRestaurants < ActiveRecord::Migration
  def change
    create_table :location_index_restaurants do |t|
      t.references :restaurant, index: true
      t.references :location_index, index: true

      t.timestamps
    end
  end
end
