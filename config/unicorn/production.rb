APP_PATH = '/home/deployer/applications/ejans'

worker_processes 1
working_directory "#{APP_PATH}/current" # available in 0.94.0+
listen '/tmp/unicorn.ejans.sock', :backlog => 64
timeout 30
pid "#{APP_PATH}/shared/pids/unicorn.pid"
stderr_path "#{APP_PATH}/shared/log/unicorn.stderr.log"
stdout_path "#{APP_PATH}/shared/log/unicorn.stdout.log"