require "bundler/capistrano"

load "config/recipes/base"
# load "config/recipes/bluepill"
load "config/recipes/monit"
load "config/recipes/default"
load "config/recipes/mongoid"
load "config/recipes/nginx"
load "config/recipes/nodejs"
load "config/recipes/resque"
load "config/recipes/rvm"
load "config/recipes/unicorn"
load "config/recipes/whenever"

server "ejans.com", :web, :app, :db, primary: true

set :user, "deployer"
set :application, "ejans"
set :deploy_to, "/home/#{user}/applications/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:cihad/#{application}.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases