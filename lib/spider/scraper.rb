module Spider
  
  class Scraper
    
    def self.process(type, page, options = {})
      case type
      when "course"
        if options[:course_page]
          { :website_url => page.search(".address a").first.try(:attr, :href) }
        elsif options[:deal_page]
          name = page.search(".tth2 strong").text
          golfnow_url = "http://www.golfnow.com" + page.search(".subCourseContent .courseName a").first.attr(:href) rescue "" 
          location = page.search(".subCourseContent .address").children.select{ |x| x.class != Nokogiri::XML::Element }.join(", ") rescue ""
          #phone = box.search(".address span:nth-child(2)").text.gsub(/[^\d]/, "")
          { :name => name, :location => location, :golfnow_url => golfnow_url }
        end
      when "deals"
        results = []
        date = ''
        page.search("#up_container span > table tr").each_with_index do |row, index|
          if row.search(".day").present?
            date = row.search(".day").text + Date.today.year.to_s
          # elsif index > 6
          #   next
          else
            row.search(".result").each do |result|
              url = "http://www.golfnow.com" + result.search(".time a").first.attr(:href)
              url_node = result.search(".time a").first
              time = url_node.text
              tee_time = Time.parse("#{date} #{time}")
              course = result.search(".courseName").text
              cost_per_player = result.search(".cost").text.match(/^\$\d+\.\d+/).to_s.match(/\d+\.\d+/).to_s.to_f
              minimum_players = result.search(".player").text.scan(/\d+/).collect(&:to_i).min
              maximum_players = result.search(".player").text.scan(/\d+/).collect(&:to_i).max
              percentage_savings = result.search(".savings").text.match(/\d+%/).to_s.presence.try(:to_i)
              details = result.search(".icons a img").collect{ |img| img.attr(:alt) }
              results << {
                :tee_time => tee_time,
                :url => url,
                :url_node => url_node,
                :course => course,
                :cost_per_player => cost_per_player,
                :minimum_players => minimum_players,
                :maximum_players => maximum_players,
                :percentage_savings => percentage_savings,
                :includes_cart => details.include?("Cart Included"),
                :number_of_holes => details.include?("18 Hole Time") ? 18 : (details.include?("9 Hole Time") ? 9 : nil),
                :includes_practice_balls => details.include?("Practice Balls"),
                :includes_gps => details.include?("GPS Included")
              }
            end
          end
        end
        results
      end
    end
  end
  
end