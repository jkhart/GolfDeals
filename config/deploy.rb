$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'

set :application, "golfdeals"
set :repository, "git@github.com:jkhart/GolfDeals.git"

set :scm, :git

set :user, "jkhart"
set :use_sudo, false
set :port, 1492
set :rvm_type, :user

set :deploy_to, "/home/#{user}/projects/#{application}"
set :rvm_ruby_string, "1.9.2-p180@golf-now"
set :domain, "rebreak.it"

role :web, "jkhart.com"
role :app, "jkhart.com"
role :db,  "jkhart.com", :primary => true

after "deploy:symlink", "deploy:copy_database_yml"
after "deploy:symlink", "deploy:copy_setup_load_paths"
after "deploy:symlink", "deploy:bundle_gems"
after "deploy:symlink", "deploy:assets"
after "deploy:symlink", "symlink:uploads"
after "deploy:symlink", "symlink:cache"
after "deploy:symlink", "symlink:rvmrc"
after "deploy:symlink", "deploy:migrate"
after "deploy:restart", "deploy:whenever:rebuild"


namespace :deploy do
  desc "bundle install gems to current/vendor/gems and symlink it shared/vendor/gems"
  task :bundle_gems do
    run "ln -s #{shared_path}/vendor/gems #{current_path}/vendor/gems"
    run "cd #{current_path} && rvm #{rvm_ruby_string} exec bundle install"
  end
  desc "Copy the database.yml file in shared/config to the current release"
  task :copy_database_yml do
    run "cp #{shared_path}/config/database.yml #{current_path}/config/database.yml"
  end
  desc "Copy the setup_load_paths.rb file in shared/config to the current release"
  task :copy_setup_load_paths do
    run "cp #{shared_path}/config/setup_load_paths.rb #{current_path}/config/setup_load_paths.rb"
  end
  task :start do ; end
  task :stop do ; end
  desc "Restart the server"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  desc "Run rake db:migrate on the server"
  task :migrate, :roles => :app do
    run "cd #{current_path} && rvm #{rvm_ruby_string} exec rake db:migrate RAILS_ENV=#{defined?(stage) ? stage.to_s : 'production'} --trace"
  end
  namespace :whenever do
    desc "Update the crontab file"
    task :rebuild, :roles => :db do
      run "cd #{current_path} && whenever --update-crontab #{application}"
    end
  end
  desc "Compile asets"
  task :assets do
    run "cd #{current_path} && rvm #{rvm_ruby_string} exec rake assets:precompile RAILS_ENV=#{rails_env} --trace";
  end
end

namespace :symlink do
  desc "Symlink the cache directory from current/public/cache to shared/cache"
  task :cache, :roles => :app, :except => { :no_release => true } do
    run "ln -nfs #{shared_path}/cache #{current_path}/public/cache"
  end
  desc "Symlink the uploads directory from current/public/uploads to shared/uploads"
  task :uploads, :roles => :app, :except => { :no_release => true } do
    run "ln -nfs #{shared_path}/uploads #{current_path}/public/uploads"
    run "rm -r #{current_path}/public/system"
  end
  desc "Symlink current/.rvmrc to shared/rvmrc"
  task :rvmrc, :roles => :app, :except => { :no_release => true } do
    run "ln -nfs #{shared_path}/rvmrc #{current_path}/.rvmrc"
  end
end

namespace :cache do
  desc "Clear the pages of the cache"
  task :clear, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path}; rake cache:clear RAILS_ENV=#{defined?(stage) ? stage.to_s : 'production'} --trace"
  end
  desc "Build the pages of the cache"
  task :build, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path}; rake cache:build RAILS_ENV=#{defined?(stage) ? stage.to_s : 'production'} --trace"
  end
  desc "Rebuild the pages of the cache"
  task :rebuild, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path}; rake cache:rebuild RAILS_ENV=#{defined?(stage) ? stage.to_s : 'production'} --trace"
  end
end

namespace :db do
  desc "Get a database and put it on the current environment"
  task :get, :roles => :app, :except => { :no_release => true } do
    current_env = ENV['CURRENT_ENV'] || 'development'
    if current_env != "production" || ENV['FORCE']
      structure_filename = "#{Date.today.to_s}-structure.dmp"
      data_filename = "#{Date.today.to_s}-data.dmp"
      from = YAML::load_file("config/database.yml")[defined?(stage) ? stage.to_s : 'production']
      to = YAML::load_file("config/database.yml")[current_env]
      run "mkdir -p #{shared_path}/databases"
      host_options = { "to" => (to["host"] ? "-h #{to['host']}" : ""), "from" => (from["host"] ? "-h #{from['host']}" : "") }
      password_options = { "to" => (to["password"] ? "-p#{to['password']}" : ""), "from" => (from["password"] ? "-p#{from['password']}" : "") }
      run "mysqldump -u #{from['username']} #{host_options['from']} #{password_options['from']} #{from['database']} --skip-extended-insert --set-charset --no-data > #{shared_path}/databases/#{structure_filename}"
      run "mysqldump -u #{from['username']} #{host_options['from']} #{password_options['from']} #{from['database']} --skip-extended-insert --set-charset --no-create-info > #{shared_path}/databases/#{data_filename}"
      run "cd #{shared_path}/uploads/; zip -r #{shared_path}/uploads.zip *"
      system("mkdir -p db/backups")
      system("scp -oPort=#{port} #{user}@#{domain}:#{shared_path}/databases/#{structure_filename} db/backups/#{structure_filename}")
      system("scp -oPort=#{port} #{user}@#{domain}:#{shared_path}/databases/#{data_filename} db/backups/#{data_filename}")
      system("scp -oPort=#{port} #{user}@#{domain}:#{shared_path}/uploads.zip public/uploads.zip")
      run "rm -r #{shared_path}/databases/"
      run "rm #{shared_path}/uploads.zip"
      system("rake db:drop RAILS_ENV=#{current_env} --trace; rake db:create RAILS_ENV=#{current_env} --trace")
      system("rm -rf public/uploads")
      system("mysql -u #{to['username']} #{host_options['to']} #{password_options['to']} #{to['database']} < db/backups/#{structure_filename}")
      system("mysql -u #{to['username']} #{host_options['to']} #{password_options['to']} #{to['database']} < db/backups/#{data_filename}")
      system("unzip public/uploads.zip -d public/uploads")
      system("rm public/uploads.zip")
      system("rake db:migrate RAILS_ENV=#{current_env} --trace")
    else
      puts "if you want to get a database to production, you must pass 'FORCE=true'"
    end
  end
end

namespace :db do
  desc "Put the current environment's database on a specific server"
  task :put, :roles => :app, :except => { :no_release => true } do
    if stage.to_s != "production" || ENV['FORCE']
      current_env = ENV['CURRENT_ENV'] || 'development'
      structure_filename = "#{Date.today.to_s}-structure.dmp"
      data_filename = "#{Date.today.to_s}-data.dmp"
      to = YAML::load_file("config/database.yml")[defined?(stage) ? stage.to_s : 'production']
      from = YAML::load_file("config/database.yml")[current_env]
      system "mkdir -p db/backups"
      host_options = { "to" => (to["host"] ? "-h #{to['host']}" : ""), "from" => (from["host"] ? "-h #{from['host']}" : "") }
      password_options = { "to" => (to["password"] ? "-p#{to['password']}" : ""), "from" => (from["password"] ? "-p#{from['password']}" : "") }
      system "mysqldump -u #{from['username']} #{host_options['from']} #{password_options['from']} #{from['database']} --skip-extended-insert --set-charset --no-data > db/backups/#{structure_filename}"
      system "mysqldump -u #{from['username']} #{host_options['from']} #{password_options['from']} #{from['database']} --skip-extended-insert --set-charset --no-create-info > db/backups/#{data_filename}"
      system "cd public/uploads/; zip -r uploads.zip *"
      system "mv public/uploads/uploads.zip public/uploads.zip"
      run "mkdir -p #{shared_path}/databases"
      run "mkdir -p #{shared_path}/uploads"
      run "rm -r #{shared_path}/uploads/"
      system "scp -oPort=#{port} db/backups/#{structure_filename} #{user}@#{domain}:#{shared_path}/databases/#{structure_filename}"
      system "scp -oPort=#{port} db/backups/#{data_filename} #{user}@#{domain}:#{shared_path}/databases/#{data_filename}"
      system "scp -oPort=#{port} public/uploads.zip #{user}@#{domain}:#{shared_path}/uploads.zip"
      run "cd #{current_path} && rake db:drop RAILS_ENV=#{defined?(stage) ? stage.to_s : 'production'} --trace; rake db:create RAILS_ENV=#{defined?(stage) ? stage.to_s : 'production'} --trace"
      run "mysql -u #{to['username']} #{host_options['to']} #{password_options['to']} #{to['database']} < #{shared_path}/databases/#{structure_filename}"
      run "mysql -u #{to['username']} #{host_options['to']} #{password_options['to']} #{to['database']} < #{shared_path}/databases/#{data_filename}"
      run "unzip #{shared_path}/uploads.zip -d #{shared_path}/uploads"
      run "rm #{shared_path}/uploads.zip"
      run "cd #{current_path} && rake db:migrate RAILS_ENV=#{defined?(stage) ? stage.to_s : 'production'} --trace"
      run "rm -r #{shared_path}/databases/"
      system "rm public/uploads.zip"
      system "rm -r db/backups/" if current_env == "production"
    else
      puts "if you want to put your database to production, you must pass 'FORCE=true'"
    end
  end
end