namespace :deploy do
  desc "Config symlink"
  task :app_config, roles: :app do
    # run "ln -nfs #{shared_path}/config/app_config.yml #{release_path}/config/app_config.yml"
  end
  before "unicorn:start", "deploy:app_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes"
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end