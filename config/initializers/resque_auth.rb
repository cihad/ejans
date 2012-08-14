if APP_CONFIG['authentication']
  Resque::Server.use(Rack::Auth::Basic) do |user, password|
    password == APP_CONFIG['resque_ui_password']
  end
end