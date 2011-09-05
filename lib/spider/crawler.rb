module Spider
  
  class Crawler
    
    def self.new
      agent = Mechanize.new
      agent.user_agent = 'Mac FireFox'
      agent
    end
    
  end
  
end