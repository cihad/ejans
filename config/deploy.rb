require "bundler/capistrano"

set :application, "ejans"
set :domain, "ejans.com"
set :repository,  "."
set :scm, :none
set :user, 'root'
set :use_sudo, false
set :deploy_to, "/var/www/#{application}"
set :deploy_via, :copy
set :unicorn_pid, "/var/www/#{application}/shared/pids/unicorn.pid"
set :rails_env, :production

role :web, domain
role :app, domain
role :db,  domain, :primary => true

default_environment["RAILS_ENV"] = 'production'

after "deploy", "rvm:trust_rvmrc"
after "deploy", "thinking_sphinx:start"
after "deploy", "unicorn:reload"
after "deploy:restart", "deploy:cleanup"
after "deploy:update_code", "assets:precompile"



# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
# Load RVM's capistrano plugin.
require "rvm/capistrano"
# Or whatever env you want it to run in.
set :rvm_ruby_string, '1.9.2@ejans'
# Copy the exact line. I really mean :user here
set :rvm_type, :user
set :rvm_bin_path, "/usr/local/rvm/bin"

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  expand_path
end

namespace :rake do  
  desc "Run a task on a remote server."  
  # run like: cap staging rake:invoke task=a_certain_task  
  task :invoke do  
    run("cd #{deploy_to}/current && bundle exec rake #{ENV['task']} RAILS_ENV=#{rails_env}")  
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

namespace :assets do
  desc "Precompile assets"
  task :precompile do
    run("cd #{release_path}; RAILS_ENV=#{rails_env} RAILS_GROUPS=assets bundle exec rake assets:precompile")
  end
end

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