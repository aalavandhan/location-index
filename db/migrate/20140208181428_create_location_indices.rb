class CreateLocationIndices < ActiveRecord::Migration
  def change
    create_table :location_indices do |t|
      t.string :coordinate_a
      t.string :coordinate_b
      t.string :coordinate_c
      t.string :coordinate_d
      t.references :city

      t.timestamps
    end
  end
end
