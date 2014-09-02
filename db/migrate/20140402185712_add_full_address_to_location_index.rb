class AddFullAddressToLocationIndex < ActiveRecord::Migration
  def change
  	add_column :location_indices, :full_address, :string
  end
end
