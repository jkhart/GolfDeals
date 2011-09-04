set :rails_env, "staging"
set :branch, "staging"
set :deploy_to, "/home/#{user}/projects/#{application}/#{rails_env}"
set :rvm_ruby_string, "1.9.2-p180@#{application}_#{rails_env}"
set :domain, "#{application}.com"
