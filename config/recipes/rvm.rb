# This file uses "rvm-capistrano" gem
# https://github.com/wayneeseguin/rvm-capistrano
set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")
set :rvm_install_ruby_params, '--1.9'      # for jruby/rbx default to 1.9 mode

before 'deploy:setup', 'rvm:install_rvm'   # install RVM
before 'deploy:setup', 'rvm:install_ruby'  # install Ruby and create gemset, or:
before 'deploy:setup', 'rvm:create_gemset' # only create gemset

require "rvm/capistrano"