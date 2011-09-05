module Spider
  
  class Locator
    
    def self.find(city, state)
      {
        "CA" => {
          "San Francisco" => "http://www.golfnow.com/sanfrancisco/tee-times/hot-deals/search"
        },
        "PA" => {
          "Pittsburgh" => "http://www.golfnow.com/pittsburgh/tee-times/hot-deals/search"
        },
        "DC" => {
          "Washington" => "http://www.golfnow.com/washingtondc/tee-times/hot-deals/search"
        }
      }[state][city]
    end
    
  end
  
end