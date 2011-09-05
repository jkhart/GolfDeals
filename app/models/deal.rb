class Deal < ActiveRecord::Base
  
  belongs_to :golf_course
  
  scope :future, Proc.new{ where("tee_time > '#{Time.zone.now.to_s(:db)}'").order("tee_time ASC") }
  
  validates :tee_time, :presence => true, :uniqueness => { :scope => :golf_course_id }
  validates :cost_per_player, :presence => true
  validates :minimum_players, :presence => true
  validates :maximum_players, :presence => true
  validates :percentage_savings, :presence => true
  validates :url, :presence => true, :uniqueness => { :scope => :golf_course_id }
end
