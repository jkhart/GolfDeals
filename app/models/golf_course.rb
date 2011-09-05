class GolfCourse < ActiveRecord::Base
  
  has_many :deals
  
  validates :name, :presence => true, :uniqueness => true
  validates :location, :presence => true
  validates :latitude, :presence => true
  validates :longitude, :presence => true
  
  geocoded_by :location
  before_validation :geocode, :if => :location_changed?
  
  acts_as_gmappable :process_geocoding => false, :address => :location
  
  # def gmaps4rails_address
  #   self.location
  # end
  
  def gmaps4rails_infowindow
    "<h3 data-id='#{self.id}'>#{self.name}</h3><p>#{self.location.gsub(', ', '<br />')}</p><p><a href='#' class='infoWindow'>See Deals</a></p>"
  end
  
end
