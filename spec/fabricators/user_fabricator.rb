Fabricator :user do
  username {  Faker::Internet.user_name.gsub('.', '_') }
  email { Faker::Internet.email }
  password "123456"
  password_confirmation "123456"
  role :registered
end
