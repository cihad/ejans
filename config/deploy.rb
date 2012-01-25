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
    run "rvm rvmrc trust #{latest_release}"
  end
end


# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

# Load RVM's capistrano plugin.
require "rvm/capistrano"

# Or whatever env you want it to run in.
set :rvm_ruby_string, '1.9.2@proje'

# Copy the exact line. I really mean :user here
set :rvm_type, :user

set :rvm_bin_path, "/usr/local/rvm/bin"