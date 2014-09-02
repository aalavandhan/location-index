class RemoveCoordinateStringFieldsFromLocationIndex < ActiveRecord::Migration
  def change
  	remove_column :location_indices, :coordinate_a
  	remove_column :location_indices, :coordinate_b
  	remove_column :location_indices, :coordinate_c
  	remove_column :location_indices, :coordinate_d
  end
end
