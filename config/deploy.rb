require "bundler/capistrano"
require 'thinking_sphinx/deploy/capistrano'

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
after "deploy:restart", "deploy:cleanup"
before "deploy:update_code", "ts:stop" # Uncomment first_run
after "deploy:symlink", "ts:symlink"
after "deploy:symlink", "deploy:restart_workers" # Uncomment first_run
after 'deploy', 'ts:start'
after "deploy", "uploads:symlink"
after "deploy", "assets:precompile"
after "deploy", "unicorn:restart"


# Copy the exact line. I really mean :user here
# https://rvm.beginrescueend.com/integration/capistrano/
set :rvm_type, :user

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

  desc "restart unicorn"
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
end

namespace :assets do
  desc "Precompile assets"
  task :precompile do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
  end
end

namespace :ts do
  desc "Stop Sphinx!"
  task :index, :roles => :app do
    thinking_sphinx.index
  end

  desc "Stop Sphinx!"
  task :stop, :roles => :app do
    thinking_sphinx.stop
  end

  desc "Re-establish symlinks"
  task :symlink do
    run <<-CMD
      rm -rf #{release_path}/db/sphinx &&
      ln -nfs #{shared_path}/db/sphinx #{release_path}/db/sphinx
    CMD
  end

  desc "Symlink, Configure and Start Sphinx!"
  task :start, :roles => :app do
    thinking_sphinx.configure
    thinking_sphinx.start
  end

  desc "Link up Sphinx's indexes."
  task :symlink_sphinx_indexes, :roles => :app do
    run "ln -nfs #{shared_path}/db/sphinx #{current_path}/db/sphinx"
  end
end

namespace :uploads do
  desc "Symlink"
  task :symlink, :except => { :no_release => true } do
    run <<-CMD
      rm -rf #{release_path}/public/uploads && ln -nfs #{shared_path}/uploads #{release_path}/public/uploads
    CMD
  end
end

namespace :es do 
  desc "Get links"
  task :get do 
    cmd = "cd #{current_path} && bundle exec rake bot"
    run cmd
  end
end

# https://gist.github.com/797301
def run_remote_rake(rake_cmd)
  rake_args = ENV['RAKE_ARGS'].to_s.split(',')
  cmd = "cd #{current_path} && bundle exec rake RAILS_ENV=#{rails_env} #{rake_cmd}"
  run cmd
  set :rakefile, nil if exists?(:rakefile)
end

namespace :deploy do
  desc "Restart Resque Workers"
  task :restart_workers, :roles => :db do
    run_remote_rake "resque:restart_workers"
  end
end