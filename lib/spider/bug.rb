module Spider
  
  class Bug
    attr_accessor :legs, :city, :state, :deals
    
    
    def initialize(options = {})
      self.city = options[:city] || "San Francisco"
      self.state = options[:state] || "CA"
      self.legs = Crawler.new
    end
    
    def retrieve_and_disect
      self.retrieve
      self.disect
    end
    
    def retrieve
      self.deals = Scraper.process("deals", self.legs.get(Locator.find(city, state)))
    end
    
    def disect
      self.deals.each do |deal|
        course = GolfCourse.find_by_name(deal.delete(:course))
        if course.blank?
          sleep(8)
          course_attributes = Scraper.process("course", self.legs.click(deal.delete(:url_node)), :deal_page => :true)
          course = GolfCourse.create(course_attributes)
          unless course.new_record?
            sleep(2)
            course.update_attributes(Scraper.process("course", self.legs.get(course.golfnow_url), :course_page => :true))
          end
        else
          deal.delete(:url_node)
        end
        course.deals.create(deal) unless course.new_record?
      end
    end
    
  end
  
end