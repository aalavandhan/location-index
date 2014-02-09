class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :address
      t.string :locality
      t.float :rating_editor_overall
      t.float :cost_for_two
      t.boolean :has_discount
      t.timestamps
    end
  end
end
