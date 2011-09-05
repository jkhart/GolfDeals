module Spider
  
  class Locator
    
    def self.find(city, state)
      {
        "CA" => {
          "San Francisco" => "http://www.golfnow.com/sanfrancisco/tee-times/hot-deals/search"
        }
      }[state][city]
    end
    
  end
  
end