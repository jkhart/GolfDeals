# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :deal do
    association(:golf_course)
    tee_time 4.hours.from_now
    cost "$28 / player"
    players "1 - 4 players"
    url "http:www.golfnow.com"
    savings "45%"
    number_of_holes 18
  end
end