source 'http://rubygems.org'

gem 'rails', '3.2.0'
gem 'mysql2'
gem 'jquery-rails'

gem 'devise', '2.0.0'
gem 'breadcrumbs', '~> 0.1.6'
gem 'rack-pjax'
gem 'kaminari'
gem 'friendly_id', '~> 4.0.0.beta14'
gem 'cancan'
gem 'thinking-sphinx', '2.0.10'

gem 'resque', :require => "resque/server"
gem 'sinatra', '~> 1.2.6'
gem 'roadie'
gem 'tinymce-rails'
gem 'carrierwave'
gem 'nokogiri'
gem 'rails-i18n'

# Groups
group :assets do
  gem 'sass', git: 'git://github.com/nex3/sass.git'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
  gem 'faker'
  gem 'capistrano'
  gem 'populator'
  gem 'railroady'
  gem 'libnotify'
end

group :production do
  gem 'unicorn', '4.1.1'
end

group :test, :development do
  gem 'rspec-rails'
end

group :test do
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'guard-rspec'
end