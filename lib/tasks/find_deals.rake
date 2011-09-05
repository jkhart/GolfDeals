desc "search golfnow for deals"
task :find_deals => :environment do
  bug = Spider::Bug.new(:city => "San Francisco", :state => "CA")
  bug.retrieve_and_disect
  bug = Spider::Bug.new(:city => "Pittsburgh", :state => "PA")
  bug.retrieve_and_disect
end