source 'http://rubygems.org'

gem "rails", "3.1.0"

gem "jquery-rails"
gem 'sass-rails'
gem 'coffee-script'
gem 'uglifier'
gem 'libxml-ruby', '>= 0.8.3'
gem 'execjs'
gem 'therubyracer'

# Used to add extensions to the active record find/where methods
#gem "meta_where"

gem "mysql2"

group :development do
  gem "capistrano"
  gem "capistrano-ext"
  gem "annotate"
  gem "rails3-generators"
  gem "rails_best_practices"
  gem "awesome_print"
  gem "nifty-generators"
end

# Very good at web crawling (can be used for caching)
gem "mechanize"

# Whenever gem, simple schedule.rb file to manage cron jobs.
gem "whenever"
gem 'chronic'
    
# Gems related to testing
group :development, :test do
  gem "rspec-rails"
  gem "factory_girl"
  gem 'factory_girl_rails'
end

group :test do
  gem "guard-rspec"
  gem "capybara"
  gem "launchy"
  gem 'timecop'
  if RUBY_PLATFORM.downcase.include?("darwin")
    gem 'rb-fsevent'
    gem "growl"
  end
  gem 'turn', :require => false
  gem 'simplecov', '>= 0.4.0', :require => false
  gem "webrat"
  gem "mocha"
end
