# This file uses "rvm-capistrano" gem
# https://github.com/wayneeseguin/rvm-capistrano
set :default_environment, {
  'PATH' => "/usr/local/rvm/gems/ruby-1.9.3-p286/bin:/usr/local/rvm/gems/ruby-1.9.3-p286@global/bin:/usr/local/rvm/rubies/ruby-1.9.3-p286/bin:/usr/local/rvm/bin:$PATH",
  'RUBY_VERSION' => 'ruby 1.9.3p286',
  'GEM_HOME' => '/usr/local/rvm/gems/ruby-1.9.3-p286',
  'GEM_PATH' => '/usr/local/rvm/gems/ruby-1.9.3-p286:/usr/local/rvm/gems/ruby-1.9.3-p286@global'
}