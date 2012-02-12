class CreatePlanets < ActiveRecord::Migration
  def change
    create_table :planets do |t|
      t.string :name
      t.string :color
      t.string :aphelion
      t.string :perihelion
      t.string :semimajor_axis
      t.float :orbital_period
      t.integer :equatorial_radius

      t.timestamps
    end
  end
end
