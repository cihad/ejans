Resque::Server.use(Rack::Auth::Basic) do |user, password|
  password == "Chad1234"
end