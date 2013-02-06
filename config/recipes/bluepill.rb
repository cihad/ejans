namespace :bluepill do
  desc "|DarkRecipes| Install the bluepill monitoring tool"
  task :install, :roles => [:app] do
    sudo "gem install bluepill"
    run "#{sudo} touch /etc/syslog.conf"
    run "#{sudo} echo 'local6.*          /var/log/bluepill.log' >> /etc/syslog.conf"
    run "#{sudo} mkdir -p /var/run/bluepill"
  end
  after 'deploy:setup' do
    install if Capistrano::CLI.ui.agree("Do you want to install the bluepill monitor? [Yn]")
  end
  
  desc "|DarkRecipes| Stop processes that bluepill is monitoring and quit bluepill"
  task :quit, :roles => [:app] do
    args = options || ""
    begin
      sudo "bluepill stop #{args}"
    rescue
      puts "Bluepill was unable to finish gracefully all the process"
    ensure
      sudo "bluepill quit"
    end
  end
  
  desc "|DarkRecipes| Load the pill from {your-app}/config/production.pill"
  task :init, :roles =>[:app] do
    sudo "bluepill load #{current_path}/config/production.pill"
  end
  after "deploy", "bluepill:init"

  desc "|DarkRecipes| Starts your previous stopped pill"
  task :start, :roles =>[:app] do
    args = options || ""
    sudo "bluepill start #{args}"
  end
  after "deploy:start", "bluepill:start"
  
  desc "|DarkRecipes| Stops some bluepill monitored process"
  task :stop, :roles =>[:app] do
    args = options || ""
    sudo "bluepill stop #{args}"
  end
  after "deploy:stop", "bluepill:stop"
  
  desc "|DarkRecipes| Restarts the pill from {your-app}/config/production.pill"
  task :restart, :roles =>[:app] do
    args = options || ""
    sudo "bluepill restart #{args}"
  end
  after "deploy:restart", "bluepill:restart"

  desc "|DarkRecipes| Prints bluepills monitored processes statuses"
  task :status, :roles => [:app] do
    args = options || ""
    sudo "bluepill status #{args}"
  end
end