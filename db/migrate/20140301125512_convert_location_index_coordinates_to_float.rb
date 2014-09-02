class ConvertLocationIndexCoordinatesToFloat < ActiveRecord::Migration
  def change
  	add_column :location_indices, :latitude_a, :float
  	add_column :location_indices, :latitude_b, :float
  	add_column :location_indices, :latitude_c, :float
  	add_column :location_indices, :latitude_d, :float
		add_column :location_indices, :longitude_a, :float
		add_column :location_indices, :longitude_b, :float
		add_column :location_indices, :longitude_c, :float	
		add_column :location_indices, :longitude_d, :float
  end
end
