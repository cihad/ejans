desc "Config symlink"
task "symlink", :except => { :no_release => true }, :role => :app do
  run "ln -s #{shared_path}/config/app_config.yml #{release_path}/config/database.yml"
end
after "deploy:finalize_update", "config:symlink"