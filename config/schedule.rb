set :output, "#{path}/log/rake.log"

every 4.hours do
  rake "find_deals"
end