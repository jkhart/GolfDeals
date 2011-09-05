class DealsController < ApplicationController
  
  def index
    @golf_courses = GolfCourse.includes(:deals)
    @golf_courses = @golf_courses.near(params[:location], params[:distance]) if params[:location].present? && params[:distance].present?
    @golf_courses = @golf_courses.where("deals.tee_time > '#{Time.zone.now.to_s(:db)}'")
    @golf_courses = @golf_courses.where("deals.percentage_savings >= ?", params[:savings]) if params[:savings].present?
    @golf_courses = @golf_courses.where("deals.cost_per_player >= ?", params[:minimum_cost]) if params[:minimum_cost].present?
    @golf_courses = @golf_courses.where("deals.cost_per_player <= ?", params[:maximum_cost]) if params[:maximum_cost].present?
    @golf_courses = @golf_courses.where("deals.maximum_players >= ?", params[:players].to_i).where("deals.minimum_players <= ?", params[:players].to_i) if params[:players].present?
    @golf_courses = @golf_courses.where("deals.includes_cart" => true) if params[:cart].present?
    @golf_courses = @golf_courses.select{ |golf_course| golf_course.deals.any?{ |deal| params[:dates].include?(deal.tee_time.to_date.to_s(:db)) } } if params[:dates].present?
  end
  
  def show
    @golf_course = GolfCourse.find_by_name(params[:id])
    @deals = @golf_course.deals.future
    @deals = @deals.where("percentage_savings >= ?", params[:savings]) if params[:savings].present?
    @deals = @deals.where("cost_per_player >= ?", params[:minimum_cost]) if params[:minimum_cost].present?
    @deals = @deals.where("cost_per_player <= ?", params[:maximum_cost]) if params[:maximum_cost].present?
    @deals = @deals.where("maximum_players >= ? AND minimum_players <= ?", params[:players], params[:players]) if params[:players].present?
    @deals = @deals.select{ |deal| params[:dates].include?(deal.tee_time.to_date.to_s(:db)) } if params[:dates].present?
    respond_to do |format|
      format.js {}
    end
  end

end
