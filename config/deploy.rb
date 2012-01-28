require "bundler/capistrano"

set :application, "ejans"
set :domain, "ejans.com"

set :repository,  "."
set :scm, :none
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# User account on the remote server
set :user, 'deploy'
set :use_sudo, false

# Directory on the server where the
# application will reside.
set :deploy_to, "/var/www/#{application}"

# Remote Cache Strategy
# Updates a remote copy of the code instead of
# doing a full checkout every time.
set :deploy_via, :copy

# Your HTTP server, Apache/etc
role :web, domain

# This may be the same as your `Web` server
role :app, domain

# This is where Rails migrations will run
role :db,  domain, :primary => true
role :db,  domain

# after "deploy", "deploy:bundle_gems"
# after "deploy:bundle_gems", "deploy:restart"
after "deploy", "rvm:trust_rvmrc"
after "deploy", "thinking_sphinx:start"
after "deploy", "unicorn:reload"
# after "deploy:update_code", "assets:precompile"
after "deploy:restart", "deploy:cleanup"

set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

set :rails_env, :production


# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
# Load RVM's capistrano plugin.
require "rvm/capistrano"
# Or whatever env you want it to run in.
set :rvm_ruby_string, '1.9.2@ejans'
# Copy the exact line. I really mean :user here
set :rvm_type, :user
set :rvm_bin_path, "/usr/local/rvm/bin"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :bundle_gems do
#     run "cd #{deploy_to}/current && bundle install vendor/gems"
#   end
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end

namespace :unicorn do
  desc "start unicorn"
  task :start, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && bundle exec unicorn -c #{current_path}/config/unicorn.rb -E #{rails_env} -D"
  end
  desc "stop unicorn"
  task :stop, :roles => :app, :except => { :no_release => true } do 
    run "kill `cat #{unicorn_pid}`"
  end
  desc "graceful stop unicorn"
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "kill -s QUIT `cat #{unicorn_pid}`"
  end
  desc "reload unicorn"
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "kill -s USR2 `cat #{unicorn_pid}`"
  end

  after "deploy:restart", "unicorn:reload"
end

namespace :rake do  
  desc "Run a task on a remote server."  
  # run like: cap staging rake:invoke task=a_certain_task  
  task :invoke do  
    run("cd #{deploy_to}/current && bundle exec rake #{ENV['task']} RAILS_ENV=#{rails_env}")  
  end  
end

# namespace :assets do
#   desc "Precompile assets"
#   task :precompile do
#     run("cd #{current_path} && bundle exec rake assets:precompile")
#   end
# end

namespace :thinking_sphinx do
  desc "Index Sphinx" 
  task :index do
    run "cd #{current_path} && bundle exec rake thinking_sphinx:index"
  end

  desc "Start Sphinx" 
  task :start do
    run "cd #{current_path} && bundle exec rake thinking_sphinx:start"
  end

  desc "Start Sphinx" 
  task :rebuild do
    run "cd #{current_path} && bundle exec rake thinking_sphinx:rebuild"
  end
end