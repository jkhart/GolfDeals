class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.integer :golf_course_id
      t.datetime :tee_time
      t.string :url
      t.float :cost_per_player
      t.integer :minimum_players
      t.integer :maximum_players
      t.integer :percentage_savings
      t.text :details
      t.boolean :includes_cart
      t.integer :number_of_holes
      t.boolean :includes_practice_balls
      t.boolean :includes_gps

      t.timestamps
    end
  end
end
