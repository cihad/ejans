Fabricator :user do
  username {  sequence(:username) { |i| "username#{i}" } }
  email { Faker::Internet.email }
  password "123456"
  password_confirmation "123456"
  role :registered
end
