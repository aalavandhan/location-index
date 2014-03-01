class AddBoundsToCity < ActiveRecord::Migration
  def change
  	add_column :cities, :bounds, :string
  end
end
