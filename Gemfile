source 'http://rubygems.org'

gem 'rails', '3.2.8'
gem 'mysql2'
gem 'jquery-rails'

gem 'devise', '2.0.0'
gem 'breadcrumbs', '~> 0.1.6'
gem 'kaminari'
gem 'friendly_id', '~> 4.0.0.beta14'
gem 'cancan'
gem 'thinking-sphinx', '2.0.10'

gem 'resque', :require => "resque/server"
gem 'sinatra', '~> 1.2.6'
gem 'roadie'
gem 'tinymce-rails'
gem 'carrierwave'
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'nokogiri'
gem 'rails-i18n'
gem 'mongoid', '~> 3.0.0.rc'
gem 'mongoid-tree', :require => 'mongoid/tree'
gem 'remotipart', '~> 1.0'
gem 'mustache'
gem 'rmagick'
gem 'numbers_and_words'
gem 'whenever', :require => false
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'recaptcha', :require => 'recaptcha/rails'
gem 'geocoder'
gem 'mongoid_fulltext'
gem 'bootstrap-sass', '~> 2.1.0.0'

# Groups
group :assets do
  gem 'sass', git: 'git://github.com/nex3/sass.git'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'capistrano'
  gem 'populator'
  gem 'libnotify'
end

group :production do
  gem 'unicorn', '4.1.1'
end

group :test, :development do
  gem 'faker'
  gem 'rspec-rails'
  gem 'pry'
  gem 'guard-rspec'
end

group :test do
  gem "fabrication"
end