class CreateGolfCourses < ActiveRecord::Migration
  def change
    create_table :golf_courses do |t|
      t.string :name
      t.string :location
      t.string :golfnow_url
      t.string :website_url
      t.string :phone
      t.float :longitude
      t.float :latitude
      t.timestamps
    end
  end
end
