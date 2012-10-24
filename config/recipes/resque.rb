# This file uses "capistrano-resque" gem
# https://github.com/sshingler/capistrano-resque
require "capistrano-resque"

role :resque_worker, domain
role :resque_scheduler, domain

set :workers, { "marketing_queue" => 1 }

after "deploy:restart", "resque:restart"
