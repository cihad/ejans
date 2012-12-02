namespace :mongodb do
  desc "Install the latest stable release of Mongodb."
  task :install, roles: :db, only: { primary: true } do
    run "#{sudo} apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10"
    run "#{sudo} touch /etc/apt/sources.list.d/10gen.list"
    run "#{sudo} echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' >> /etc/apt/sources.list.d/10gen.list"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install mongodb-10gen"
  end
  after "deploy:install", "mongodb:install"
end

namespace :mongoid do
  desc "Copy mongoid config"
  task :copy do
    upload "config/mongoid.yml", "#{shared_path}/mongoid.yml", :via => :scp
  end
  after "deploy:update_code", "mongoid:copy"

  desc "Link the mongoid config in the release_path"
  task :symlink do
    run "test -f #{release_path}/config/mongoid.yml || ln -s #{shared_path}/mongoid.yml #{release_path}/config/mongoid.yml"
  end
  after "deploy:update_code", "mongoid:symlink"

  desc "Create MongoDB indexes"
  task :index do
    run "cd #{current_path} && bundle exec rake db:mongoid:create_indexes", :once => true
  end
  after "deploy:update", "mongoid:index"
end
