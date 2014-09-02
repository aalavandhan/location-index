class AddLocalityNameToLocationIndex < ActiveRecord::Migration
  def change
  	add_column :location_indices, :locality, :string
  end
end
