desc "search golfnow for deals"
task :find_deals => :environment do
  bug = Spider::Bug.new
  bug.retrieve_and_disect
end